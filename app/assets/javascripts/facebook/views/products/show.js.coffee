class App.Views.Products.Show extends Backbone.View
  el: '#modal'

  template: JST["facebook/templates/products/show"]

  form_id: '#add_to_cart'

  events:
    "change #modal #option-types select": "change_variants"

  initialize: (options) ->
    @product = options.product
    @shop = options.shop
    @product_variants = new App.Collections.ProductVariants(@product.getVariants())
    @option_types = options.option_types
    @variant_option_types = @product_variants.getOptionTypes()
    @save_options_selected = []
    @translate = options.translate
    @setElement(@el)
    @render()

  change_variants: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @variant_options = new App.Views.Products.ChangeVariantOptions
      option_types: @option_types
      product_variants: @product_variants
      target: $(e.target)
      variant_option_types: @variant_option_types
      save_options_selected: @save_options_selected
      translate: @translate
    @variant_pictures = new App.Views.Products.ChangeVariantPictures
      variant: @variant_options.variant_selected

  render: ->
    $(@el).addClass('modal-front-show-product')
    $(@el).find($('.modal-header h3')).remove()
    $(@el).find($('#notice-modal')).remove()
    $(@el).find($('.modal-body')).html(Haml.render(@template(), { locals: {
      product: @product.toJSON()
      shop: @shop.toJSON()
      variant: @product_variants.getMaster().toJSON()
      variants_option_types: @variant_option_types
      shop_option_types: @option_types.toJSON()
      translate: @translate.toJSON()
      options_unselectable: @product_variants.check_init_option_type_unselectable(@option_types.toJSON())
    }}))

    @variant_pictures = new App.Views.Products.ChangeVariantPictures
      variant: @product_variants.getMaster()

    $(@el).modal('show')
    $('.modal-backdrop').addClass('white-overlay')
    self = @

    $("#modal").on 'hide',(e) ->
      self.$el.unbind()
      Backbone.history.navigate "#/shops/" + App.current_shop, false
      $('#modal .close').bind 'click', (e) ->
        $('#modal').modal('hide')
      self.variant_options.close() if self.variant_options != undefined
    $("#add_to_cart input[type=submit]").attr("disabled", "disabled") if @product.hasVariants()


