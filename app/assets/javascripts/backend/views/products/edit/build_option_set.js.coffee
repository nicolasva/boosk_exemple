App.Views.Products.Edi ||= {}

class App.Views.Products.Edi.BuildOptionSet extends Backbone.View
  template: JST["backend/templates/products/edit/build_option_set"]

  form_id: '#build_variant_mashup'

  events:
    "click .actions-mashup button": "build_variant_mashup"
    "click .btn.back, .settings-menu a": "back_to_variant"
    "click #add-option-types": "add_option_types"
    "click .edit": "edit_option_type"

  initialize: (options) ->
    @product = @options.product
    @option_types = @options.option_types
    @option_types.off "add"
    @option_types.on "add", @optionTypeAdded
    @product_variants = @options.product_variants
    @pictures = options.pictures
    @product.set_variants = true if @product_variants.length > 0
    @translate = @options.translate


  optionTypeAdded: (option_type) ->
    if option_type.has('id') and option_type.has('values')
      @view = new App.Views.Products.OptionTypeLine
        option_type: option_type,
        edit: false
      $('tbody').append(@view.el)

  back_to_variant: (e) ->
    e.preventDefault()
    e.stopPropagation()
    $('.actions').show()
    @view = new App.Views.Products.Edit.OptionSet
      product: @product
      product_variants: @product_variants
      option_types: @option_types
      translate: @translate
      pictures: @pictures
      el: $("#app .settings-content")

  add_option_types: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @option_types.shop_id = App.current_shop
    @view = new App.Views.ProductOptionTypes.New
      collection: @option_types,
      shop_id: App.current_shop,
      modal: $('#modal'),
      translate: @translate

    $('#modal').addClass('modal-option-types')
    $('#modal .modal-body').html(@view.render().el)
    $('#modal .modal-header h3').html(@translate.views.product.new.new_attribute)
    $('#modal').modal('show')
    self = @
    $('#modal').on 'hide', (e) ->
      $('#modal').removeClass('modal-option-types')
      self.view.remove()

  edit_option_type: (e) ->
    e.preventDefault()
    e.stopPropagation()
    id = $(e.target).attr('data-id')
    option_type_el = $(e.target).parents('tr')
    option_type = @option_types.get(id)

    option_type.off "change" #unbound previous callback
    option_type.on "change", ->
      @view = new App.Views.Products.New.OptionTypeLine
        el: option_type_el,
        option_type: option_type,
        edit: true
    @view = new App.Views.ProductOptionTypes.Edit
      model: option_type,
      shop_id: App.current_shop,
      modal: $('#modal'),
      parent_tr: $(e.target).parents('tr'),
      translate: @translate

    $('#modal').addClass('modal-option-types')
    $('#modal .modal-body').html(@view.render().el)
    $('#modal .modal-header h3').html(@translate.views.product.new.edit_attribute)
    $('#modal').modal('show')
    self = @
    $('#modal').on 'hide', (e) ->
      $('#modal').removeClass('modal-option-types')
      self.view.remove()

  build_variant_mashup: (e) ->
    e.preventDefault()
    e.stopPropagation()
    unless $('.option-types').length == 0
      option_types_selected = @matrice_option_types($('.option-types'))
      unless option_types_selected.length == 0
        @product_variants.edit_variants_by_option_types(
          option_types_selected,
          @option_types,
          @product,
          @variants_to_destroy
        )

        unless @product_variants.getMaster()
          @product_variants.at(0).set({is_master: true})

        @view = new App.Views.Products.Edit.OptionSet
          product: @product
          product_variants: @product_variants
          option_types: @option_types
          translate: @translate
          pictures: @pictures
        $("#app .settings-content").html(@view.render().el)
        $('.actions').show()
    else
      new App.Views.Notice(message: "Create options ", type: 'error')


  matrice_option_types: (dom_elements) ->
    option_types_selected = new Array
    for option_type in $(dom_elements)
      option = $(option_type).find('input[type=checkbox]')
      values = new Array
      for value in option
        if $(value).is(':checked')
          values.push(parseInt($(value).attr('value')))
      option_types_selected.push values if values.length > 0
    return option_types_selected


  render: ->
    $('.actions').hide()
    $(@el).html(Haml.render(@template(), { locals: {
      option_types: @option_types.toJSON()
      product: @product
      variants_option_types: @product_variants.getOptionTypes()
      translate: @translate
      } }))
    return @
