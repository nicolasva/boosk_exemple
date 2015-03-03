App.Views.ShippingMethods ||= {}

class App.Views.ShippingMethods.Index extends Backbone.View
  template: JST["backend/templates/shipping/methods/index"]
  store_settings_menu: JST["backend/templates/shared/store_settings_menu"]
  support_block: JST["backend/templates/shared/support_block"]

  tagName: "section"
  id: "store-settings"
  className: "container-fluid"

  events:
   "change .action": "perform_action"
   "click .edit" : "edit"
   "click .select-all": "select_all"
   "click #new_method" : "new"

  initialize: (options) ->
    @translate = options.translate.toJSON()
    @shop = options.shop
    @wizard = options.wizard
    @actions =
      0: { action: "destroy", display: @translate.delete.capitalize() }
    view = @
    @collection.on 'reset', ->
      view.render()

  perform_action: (e) ->
    e.preventDefault()
    e.stopPropagation()
    perform = @actions[$(e.target).val()]
    if perform != undefined
      eval "this.#{perform['action']}()"
      $('.action option:first-child').attr('selected','selected')


  select_all: (e) ->
    $('.method-selected').attr 'checked', $(e.target).is(':checked')

  get_methods_selected: (methods) ->
    methods_selected = []
    for method in methods
      if $(method).is(':checked')
        id = $(method).parents('tr').attr('data-id')
        methods_selected.push(@collection.get(id))
    return methods_selected


  destroy: (event) ->
    methods = @get_methods_selected($('.method-selected'))
    if _.isEmpty(methods)
      @confirm = new App.Views.Popup
        translate: @translate
        message: @translate.views.shipping_method.no_method_selected_warning
        el: $('#modal .modal-body')
        mode: "alert"
    else
      self = @
      @popup = new App.Views.Popup
        translate: @translate
        message: if methods.length > 1 then @translate.views.shipping_method.warning.remove_confirm.other else @translate.views.shipping_method.warning.remove_confirm.one
        el: $('#modal .modal-body')
        mode: "confirm"
        callback: ->
          App.eventsDispatcher.trigger 'startLoading'
          self.collection.bulk_destroy methods,
            success: (models, methods) ->
              App.eventsDispatcher.trigger 'loadingComplete'
              for method in methods
                self.collection.remove self.collection.get(method.id)
                $("tr[data-id=#{method.id}]").fadeOut 500, ->
                  $("tr[data-id=#{method.id}]").remove()
            error: ->
              App.eventsDispatcher.trigger 'loadingComplete'

  new: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @modal = new App.Views.ShippingMethods.New
      collection: @collection
      el: $('#modal .modal-body')
      translate: @translate
      modal: true
    $('#modal').addClass('modal-shipping_methods')
    $('#modal .modal-header h3').html(@translate.views.shipping_method.add_shipping_method)
    $('#modal').modal('show')
    self = @
    $('#modal').one 'hidden', (e) ->
      self.collection.fetch()
      self.modal.close()
      $('#modal').removeClass('modal-shipping_methods')

  edit: (e) ->
    e.preventDefault()
    e.stopPropagation()
    id = $(e.target).parents('tr').attr('data-id')
    method = @collection.get(id)
    @modal = new App.Views.ShippingMethods.Edit
      model: method
      el: $('#modal .modal-body')
      translate: @translate
      modal: true

    $('#modal').addClass('modal-shipping_methods')
    $('#modal .modal-header h3').html(@translate.views.shipping_method.edit_shipping_method)
    $('#modal').modal('show')
    self = @
    $('#modal').one 'hidden', (e) ->
      self.collection.fetch()
      $('#modal').removeClass('modal-shipping_methods')
      self.modal.close()

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      shipping_methods: @collection.toJSON()
      translate: @translate
      actions: @actions
      wizard: @wizard
    } }))
    @.$("#store-settings-menu").html(Haml.render(@store_settings_menu(),
      locals:
        translate: @translate
        active: "shipping"
        has_active_payement: @shop.get('has_active_payement')
        wizard: @wizard
    ))
    @.$("#store-settings-menu").after(Haml.render(@support_block(),
      locals:
        translate: @translate
    ))
    return @
