App.Views.Products ||= {}
App.Views.Products.New ||= {}

class App.Views.Products.New.Step2 extends Backbone.View
  template: JST["backend/templates/products/new/step_2"]

  tagName: "section"
  id: "new_product"
  className: "container-fluid"

  form_id: '#new_variants_form'

  events:
    "submit #new_variants_form": "add_variants"
    "click #add-option-types": "add_option_types"
    "click .edit": "edit_option_type"

  initialize: (options) ->
    @product = @options.product
    @option_types = @options.option_types
    @product_variants = @options.product_variants
    @translate = @options.translate.toJSON()
    @option_types.off "add"
    @option_types.on "add", @optionTypeAdded

  optionTypeAdded: (option_type) ->
    if option_type.has('id') and option_type.has('values')
      if $('.no-items').length != 0
        $('.no-items').remove()
        $('#add-option-types, .actions input, #new_variants_form table').show()
      @view = new App.Views.Products.OptionTypeLine
        option_type: option_type,
        edit: false
      $('tbody').append(@view.el)
      $("tbody td.values[data-id=#{option_type.id}] input").attr('checked', 'checked')

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

  remove_option_type: (e) ->
    e.preventDefault()
    e.stopPropagation()
    id= $(e.target).attr('data-id')
    option_type = @option_types.get(id)
    tr = $(e.target).parents('tr')
    App.eventsDispatcher.trigger 'startLoading'
    option_type.destroy
      success: (data, reponse) ->
        App.eventsDispatcher.trigger 'loadingComplete'
        $(tr).fadeOut '500', ->
          $(tr).remove()
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'


  edit_option_type: (e) ->
    e.preventDefault()
    e.stopPropagation()
    id = $(e.target).attr('data-id')
    option_type_el = $(e.target).parents('tr')
    option_type = @option_types.get(id)

    option_type.off "change" #unbound previous callback
    option_type.on "change", ->
      @view = new App.Views.Products.OptionTypeLine
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

  add_variants: (e) ->
    e.preventDefault()
    e.stopPropagation()
    unless $('.option-types').length == 0
      option_types_selected = @matrice_option_types($('.option-types'))
      unless option_types_selected.length == 0
        @product_variants.reset()
        @product_variants.add_variants_by_option_types(
          option_types_selected,
          @option_types,
          @product
        )
        if @product.pictures?
          self = @
          @product_variants.each (variant) ->
            variant.set 'pictures_attributes', self.product.pictures
        if @product_variants.length > 0
          @product.set_variants = true
          $('#notice').html('')
          window.location.hash = "#/products/new/step_3"
      else
        new App.Views.Notice(message: @translate.views.option_type.no_option_type_selected_warning, type: 'error')
    else
      new App.Views.Notice(message: @translate.views.option_type.you_have_not_yet_option_types, type: 'error')

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
    unless @product_variants.length > 0
      $(@el).html(Haml.render(@template(), { locals: {
        option_types: @option_types.toJSON(),
        product: @product,
        translate: @translate
      } }))
    else
      $(@el).html(Haml.render(@template(), { locals: {
        option_types: @option_types.toJSON(),
        product: @product
        variants_option_types: @product_variants.getOptionTypes(),
        translate: @translate
      } }))
    return this
