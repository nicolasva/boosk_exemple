class App.Views.Shops.Show extends Backbone.View
  el: '#product_list'
  template: JST["facebook/templates/shop/show"]

  events:
    "click .track.ogp": "track_ogp"
    "click .track.pint_it":  "pint_it"
    "mouseover .picture":  "show_opacity_button"
    "mouseout .picture":  "hide_button"
    "mouseover .show":  "hide_opacity_button"

  initialize: (options) ->
    @window_open = false
    self = @
    @shop = options.shop.toJSON()
    @products_per_page = @shop.customization.products_per_page
    @last_page = 0
    @translate = options.translate.toJSON()
    @loading = true
    @taxonomies = new App.Collections.Taxonomies()
    @taxonomies.fetch
      success:(collection) ->
        $("#menu").html(new App.Views.Taxonomies.Menu(taxons: collection.first().taxons, translate: self.translate).el)
        $(".taxon, #home").bind 'click', self.navigate_by_taxon
  
    if $(@el).attr("data-lastpage") != 999999999999
      @render()
      $(window).bind "scroll", (e) ->
        self.infinity()

  navigate_by_taxon: (e) =>
    e.preventDefault()
    e.stopPropagation()
    self = @
    @init_product()
    $(@el).attr("data-taxon", $(e.currentTarget).attr("data-id")) if $(e.currentTarget).hasClass('taxon')
    $(window).bind "scroll", (e) ->
      self.infinity()
    @render()

  init_product: ->
    @last_page = 0
    $(@el).attr("data-lastpage", "0")
    $(@el).attr("data-search", "")
    $(@el).attr("data-taxon", "")
    $(@el).empty()

  hide_button: (e) ->
    e.preventDefault()
    e.stopPropagation()
    unless $(e.relatedTarget).hasClass('show')
      $(e.target).parents('.picture').find('.show').hide()

  show_opacity_button: (e) ->
    e.preventDefault()
    e.stopPropagation()
    $(e.currentTarget).find('.show').removeClass('light-opacity')
    $(e.currentTarget).find('.show').addClass('light-opacity')
    $(e.currentTarget).find('.show').show()

  hide_opacity_button: (e) ->
    e.preventDefault()
    e.stopPropagation()
    $(e.target).removeClass('light-opacity')

  products_grid: ->
    unless @shop.customization == undefined
      return @shop.customization.products_grid
    else
      return 4

  render: ->
    self = @
    @loading = true
    @products = new App.Collections.Products()
    @products.query_params = {page: parseInt(@last_page) * @products_per_page, product_per_page: @products_per_page}
    if($(@el).attr("data-search") != "" && $(@el).attr("data-search") != undefined)
      @products.query_params["query"] = $(@el).attr("data-search")
    else if($(@el).attr("data-taxon") != "" && $(@el).attr("data-taxon") != undefined)
      @products.query_params["taxon_id"] = $(@el).attr("data-taxon")
    @products.fetch
      success: (collection, response) ->
        self.last_page = self.last_page + 1
        if collection.length < self.products_per_page
          $(window).unbind "scroll"
          self.last_page = 999999999999
        new App.CommonViews.Products.Index
          next_page: self.last_page
          template: self.template()
          el: self.el
          translate: self.translate
          products_grid: self.products_grid()
          products: collection.toJSON()
          context: self

  tweet_it: (event) ->
    product_data_ref = $(event.target).parent().parent().parent().parent().attr("data-ref") 
    if @window_open == false || @window_open != "true_window_open_"+product_data_ref
      @window_open = "true_window_open_"+product_data_ref 
      location = document.URL.split("#")[0]+"#/products/"+event.target.id.split("_")[event.target.id.split("_").length-1]
      product = new App.Product(id: product_data_ref)
      product.fetch
        success: (model, response) ->
          @viewTweetItTwitter = new App.CommonViews.Twitter.TweetIt(product: product)

  pint_it: (event) ->
    product_data_ref = $(event.target).parent().parent().parent().parent().attr("data-ref")
    url_path = "http://"+window.location.hostname
    location = document.URL.split("#")[0]+"#/products/"+event.target.id.split("_")[event.target.id.split("_").length-1]
    product = new App.Product(id: product_data_ref)
    product.fetch
      success: (model, response) ->
        @viewPintItPinterest = new App.CommonViews.Pint.PintItPinterest(product: model, location: location, url_path: url_path)

  track_ogp: (event) ->
    self = @
    if App.fbSdkInit
      FB.getLoginStatus (response) ->
        if response.status == "connected" 
          FB.api '/me/permissions', (response) ->
            data_params =
              type: $(event.target).attr('data-action')
            product_id = $(event.target).parent().parent().parent().parent().attr("data-product-id")
            $.ajax({
              url: "/facebook/shops/#{App.current_shop}/products/#{product_id}/open_graphs"
              type: "POST"
              data: data_params,
              dataType: "json"
            })
        else if response.status == "not_authorized"
          self.logFBUser()
    else
      App.eventsDispatcher.on "fbSdkInit", self.logFBUser(), @
    return

  infinity: (event) ->
    if @loading==false
      offset = $(".product_thumb:last").offset()
      @last_page = parseInt($("#product_list").attr("data-lastpage"))
      if (offset.top - $(window).height() <= $(window).scrollTop())
        @render()

  logFBUser: (event) ->
    self = @
    event.stopPropagation()
    event.preventDefault()
    FB.login (response) ->
      self.track_ogp()
    ,
      scope: "user_about_me,email,publish_actions"
