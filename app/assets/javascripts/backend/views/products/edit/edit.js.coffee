App.Views.Products ||= {}
App.Views.Products.Edit ||= {}

class App.Views.Products.Edit extends Backbone.View
  template: JST["backend/templates/products/edit/layout"]

  current_step: null

  form_id: '#edit_product_form'

  events:
    "submit #edit_product_form": "update"
    "click #general": "general"
    "click #option_set": "option_sets"
    "click #shipping": "shipping"
    "click #promote": "promote"


  initialize: (options) ->
    @translate = options.translate.toJSON()
    @product = options.product
    @shop = new App.Shop(uuid: App.current_shop)
    variants = @product.getVariants()
    @product_variants = new App.Collections.ProductVariants(variants)
    @option_types = options.option_types
    pictures = @product_variants.get_pictures()
    @pictures = new App.Collections.VariantsPictures
    @pictures.add_whithout_twice pictures
    @taxes = new App.Collections.TaxRates
    @setElement(@el)
    @render()


  general: ->
    App.eventsDispatcher.trigger 'startLoading'
    $('.settings-menu li').removeClass('active')
    $('.settings-menu li.general').addClass('active')
    $('.actions').show()
    self = @
    @shop.fetch
      success: ->
        self.taxes.fetch
          success: ->
            @view = new App.Views.Products.Edit.Master
              product: self.product
              shop: self.shop
              translate: self.translate
              product_variants: self.product_variants
              option_types: self.option_types
              pictures: self.pictures
              taxes: self.taxes
              shipping_methods: self.shipping_methods
            $("#app .settings-content").html(@view.render().el)
            new Carousel
              container: $('#carousel .overflow')
              nb_visible: 4
            App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  option_sets: ->
    $('.settings-menu li').removeClass('active')
    $('.settings-menu li.option_set').addClass('active')
    @view = new App.Views.Products.Edit.OptionSet
      product: @product
      product_variants: @product_variants
      option_types: @option_types
      translate: @translate
      pictures: @pictures
      el: $("#app .settings-content")
    $('.actions').show()
  shipping: (e) ->
    #load view in $('.settings-content')

  promote: (e) ->
    #load view in $('.settings-content')

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()
    App.eventsDispatcher.trigger 'startLoading'
    data = $(@form_id).toJSON()
    @product.set(data.product)
    old_variants = @product.get_variant_ids()
    @product.add_variants_by_collection(@product_variants)
    @product.destroy_variant_by_diff(old_variants)
    @product.attributes = {product: @product.attributes}
    self = @
    @product.save @product.attributes,
      success: (product) ->
        App.eventsDispatcher.trigger 'loadingComplete'
        new App.Views.Notice(message: self.translate.views.product.notice.updated_successfully, type: 'success', size: 'large' )
        $('html, body').scrollTop(0)
        window.location.hash = "#/products"
      error: (product) ->
        App.eventsDispatcher.trigger 'loadingComplete'
        new App.Views.Notice(message: self.translate.views.product.error.update, type: 'error', size: 'large')
        $('html, body').scrollTop(0)
        window.location.hash = "#/products"

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      translate: @translate
    } }))
    @general()
    return @

  close: ->
    $(@el).unbind()
    $(@el).empty()
