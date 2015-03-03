class App.Views.Shops.Show extends Backbone.View
  el: "#product_list"
  template: JST["mobile/templates/shop/show"]

  events:
    "click .product_thumb" : "show_product"

  initialize: (options) ->
    self = @
    $("#header").show() if window.orientation == 0
    $("#title").hide()
    $(".product_lists").show()
    $("#product_show").hide()
    $("#checkout").hide()
    @shop = options.shop.toJSON()
    @products_per_page = @shop.customization.products_per_page
    @last_page = 0
    @translate = options.translate.toJSON()
    @loading = true
    @render()
    $(window).bind "scroll", (e) ->
      self.infinity()
    @taxon_and_search_event(@)

  taxon_and_search_event: (self) ->
    $("#search_products").bind "submit", (e) ->
      e.preventDefault()
      e.stopPropagation()
      self.init_product()
      $(@el).attr("data-search", $("#search_products .search_product").val())
      $(window).bind "scroll", (e) ->
        self.infinity()
      self.hide_panel()
      Backbone.history.navigate "#/shops/" + self.shop.uuid, true

    $(".item_taxon, taxon_img").bind "click", (e) ->
      e.preventDefault()
      e.stopPropagation()
      self.init_product()
      $(self.el).attr("data-taxon", $(e.currentTarget).attr("data-id"))
      $(window).bind "scroll", (e) ->
        self.infinity()
      self.render()
      self.hide_panel()
      Backbone.history.navigate "#/shops/" + self.shop.uuid, true

    $("#id_title_shop a").bind "click", (e) ->
      $(window).bind "scroll", (e) ->
        self.infinity()
      self.render()
      self.hide_panel()

  hide_panel: ->
    $(".content").animate
      "left": "0%", 
      500
    $("#panel_taxonomies").attr("href", "#/taxonomies")

  init_product: ->
    @last_page = 0
    $(@el).attr("data-search", "")
    $(@el).attr("data-taxon", "")
    $(@el).empty()

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
          products: collection.toJSON()
          context: self

  show_product: (event) ->
    if event.target.id.length > 0
      product_uuid = event.target.id.split("_")[event.target.id.split("_").length - 1]
    else
      if $(event.target).attr("class")
        product_uuid = $(event.target).parent()[0].id.split("_")[$(event.target).parent()[0].id.split("_").length - 1]
      else
        product_uuid = $(event.target).parent().parent()[0].id.split("_")[$(event.target).parent().parent()[0].id.split("_").length - 1]

    location.hash = "#/products/"+product_uuid

  infinity: (event) ->
    if @loading==false
      offset = $(".product_thumb:last").offset()
      @last_page = parseInt($("#product_list").attr("data-lastpage"))
      if (offset.top - $(window).height() <= $(window).scrollTop())
        @render()

