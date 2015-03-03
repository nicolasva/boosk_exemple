App.Views.ProductOptionTypes ||= {}

class App.Views.ProductOptionTypes.Index extends Backbone.View
  template: JST["backend/templates/product_option_types/index"]
  store_settings_menu: JST["backend/templates/shared/store_settings_menu"]
  support_block: JST["backend/templates/shared/support_block"]

  className: "container-fluid"
  id: "store-settings"

  events:
    "click #new_option_set" : "new"
    "click .edit" : "edit"
    "click .destroy" : "destroy"
    "change .action": "perform_action"
    "click .select-all": "select_all"
    "click .wizard_end": "wizard_end"

  initialize: (options) ->
    @translate = options.translate.toJSON()
    @shop = options.shop
    @actions =
      0: { action: "destroy", display: @translate.delete.capitalize() }
    @option_types = @options.option_types
    @option_types.off "add", @optionTypeAdded
    @option_types.on "add", @optionTypeAdded
    @wizard = options.wizard

  perform_action: (e) ->
    e.preventDefault()
    e.stopPropagation()
    perform = @actions[$(e.target).val()]
    if perform != undefined
      eval "this.#{perform['action']}()"
      $('.action option:first-child').attr('selected','selected')

  select_all: (e) ->
    $('.option_type-selected').attr 'checked', $(e.target).is(':checked')

  optionTypeAdded: (option_type) ->
    if option_type.has('id') and option_type.has('values')
      if $('.no-items').length != 0
        $('.no-items').remove()
        $('.action-zone, .add, section.settings-content table').show()
      @view = new App.Views.ProductOptionTypes.RowTable
        option_type: option_type,
      $("section.settings-content table tbody").append(@view.el)

  new: ->
    @view = new App.Views.ProductOptionTypes.New
      collection: @options.option_types,
      shop_id: App.current_shop,
      modal: $('#modal'),
      translate: @translate

    $('#modal').addClass('modal-option-types')
    $('#modal .modal-body').html(@view.render().el)
    $('#modal .modal-header h3').html(@translate.views.option_type.add_option_type)
    $('#modal').modal('show')
    self = @
    $('#modal').one 'hidden', (e) ->
      $('#modal').removeClass('modal-option-types')
      self.view.remove()

  edit: (e)->
    e.preventDefault()
    e.stopPropagation()
    id = $(e.target).attr('data-id')
    option_type_el = $(e.target).parents('tr')
    option_type = @option_types.get(id)

    option_type.off "change" #unbound previous callback
    option_type.on "change", ->
      @view = new App.Views.ProductOptionTypes.RowTable(
        option_type: option_type
        el: option_type_el
        translate: @translate
      )

    @view = new App.Views.ProductOptionTypes.Edit
      translate: @translate,
      model: @options.option_types.get(id),
      modal: $('#modal')

    $('#modal').addClass('modal-option-types')
    $('#modal .modal-body').html(@view.render().el)
    $('#modal .modal-header h3').html(@translate.views.option_type.edit_option_type)
    $('#modal').modal('show')
    self = @
    $('#modal').one 'hidden', (e) ->
      $('#modal').removeClass('modal-option-types')
      self.view.remove()

  get_option_types_selected: (option_types) ->
    option_types_selected = []
    for option_type in option_types
      if $(option_type).is(':checked')
        id = $(option_type).parents('tr').attr('data-id')
        option_types_selected.push(@option_types.get(id))
    return option_types_selected


  destroy: (event) ->
    option_types = @get_option_types_selected($('.option_type-selected'))
    if _.isEmpty(option_types)
      @confirm = new App.Views.Popup
        translate: @translate
        message: @translate.views.option_type.no_option_type_selected_warning
        el: $('#modal .modal-body')
        mode: "alert"
    else
      self = @
      @popup.close() if @popup != undefined
      @poup = new App.Views.Popup
        translate: @translate
        message: @translate.views.option_type.warning.remove_confirm
        el: $('#modal .modal-body')
        mode: "confirm"
        callback: ->
          App.eventsDispatcher.trigger 'startLoading'
          self.option_types.bulk_destroy option_types,
            success: (models, option_types) ->
              App.eventsDispatcher.trigger 'loadingComplete'
              for option_type in option_types
                self.option_types.remove self.option_types.get(option_type.type)
                $("tr[data-id='#{option_type.type}']").fadeOut 500, ->
                  $("tr[data-id='#{option_type.type}']").remove()
            error: ->
              App.eventsDispatcher.trigger 'loadingComplete'

  wizard_end:(e) ->
    e.preventDefault()
    e.stopPropagation()
    @confirm = new App.Views.Popup
      translate: @translate
      message: @translate.views.shop_setting.end_wizard
      el: $('#modal .modal-body')
      mode: "alert"
      callback: ->
        console.log e.currentTarget
        window.location.href = $(e.currentTarget).attr('href')
        $("header.login a:not('.chzn-single,.logout,#new-shop')").unbind('click')

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      option_types: @options.option_types.toJSON()
      actions: @actions
      translate: @translate
      wizard: @wizard
      has_active_payement: @shop.get('has_active_payement')
    } }))
    @.$("#store-settings-menu").html(Haml.render(@store_settings_menu(),
      locals:
        translate: @translate
        active: "option_types"
        has_active_payement: @shop.get('has_active_payement')
        wizard: @wizard
    ))
    @.$("#store-settings-menu").after(Haml.render(@support_block(),
      locals:
        translate: @translate
    ))
    return this
