class App.Views.Administrators.Index extends Backbone.View
  template: JST["backend/templates/administrators/index"]
  account_settings_menu: JST["backend/templates/shared/account_settings_menu"]
  support_block: JST["backend/templates/shared/support_block"]

  tagName: "section"
  id: "account-settings"
  className: "container-fluid"

  events:
    "click #new_administrator" : "new"
    "click .upgrade-plan": "upgrade_plan"
    "click .remove-administrator" : "destroy"
    "change .action": "perform_action"
    "click .select-all": "select_all"

  initialize: (options) ->
    @administrators = options.administrators
    @translate = options.translate.toJSON()
    @account = options.account
    @actions =
      0: { action: "destroy", display: @translate.delete.capitalize() }
    @render()

  select_all: (e) ->
    if $(e.target).is(':checked')
      for admin in $('.administrator-selected')
        admin.checked = true
      $("button[data-toggle='modal']").removeAttr('disabled')
    else
      for admin in $('.administrator-selected')
        admin.checked = false
      $("button[data-toggle='modal']").attr('disabled', 'disabled')


  perform_action: (e) ->
    e.preventDefault()
    e.stopPropagation()
    perform = @actions[$(e.target).val()]
    if perform != undefined
      eval "this.#{perform['action']}()"
      $('.action option:first-child').attr('selected','selected')

  destroy: (event) ->
    administrators = @get_admin_selected($('.administrator-selected'))
    if _.isEmpty(administrators)
      @confirm = new App.Views.Popup
        translate: @translate
        message: @translate.views.administrator.warning.select_administrator_before
        el: $('#modal .modal-body')
        mode: "alert"
    else
      self = @
      @popup.close() if @popup != undefined
      @popup = new App.Views.Popup
        translate: @translate
        message: if administrators.length > 1 then @translate.views.administrator.warning.remove_confirm.other else @translate.views.administrator.warning.remove_confirm.one
        el: $('#modal .modal-body')
        mode: "confirm"
        callback: ->
          App.eventsDispatcher.trigger 'startLoading'
          self.administrators.bulk_destroy administrators,
            success: (models, administrators) ->
              App.eventsDispatcher.trigger 'loadingComplete'    
              for administrator in administrators
                self.administrators.remove self.administrators.get(administrator.id)
                $("tr[data-id=#{administrator.id}]").remove()
            error: ->
              App.eventsDispatcher.trigger 'loadingComplete'

  get_admin_selected: (administrators) ->
    administrators_selected = []
    for administrator in administrators
      if $(administrator).is(':checked')
        id = $(administrator).parents('tr').attr('data-id')
        administrators_selected.push(@administrators.get(id))
    return administrators_selected
  
  upgrade_plan: (e) ->
    e.preventDefault()
    e.stopPropagation()
    new App.Views.Plans.BoxUpgrade
      message: @translate.views.administrator.forbidden_plan

  new: (e) ->
    e.preventDefault()
    e.stopPropagation()
    unless @administrators.models.length + 1 >= @account.get('plan').number_admin
      @view = new App.Views.Administrators.New
        administrators: @administrators
        account: @account
        translate: @translate
        modal: $('#modal')

      $('#modal').addClass('modal-administrators')
      $('#modal .modal-body').html(@view.render().el)
      $('#modal .modal-header h3').html(@translate.views.administrator.add)
      $('#modal').modal('show')
      self = @
      $('#modal').one 'hidden', (e) ->
        $('#modal').removeClass('modal-administrators')
        self.view.remove()
    else
      new App.Views.Plans.BoxUpgrade
        message: @translate.views.administrator.more
    

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      administrators: @administrators.toJSON()
      translate: @translate
      actions: @actions
      plan: @account.get('plan').name
    } }))
    @.$("#account-settings-menu").html(Haml.render(@account_settings_menu(),
      locals:
        translate: @translate
        active: "administrators"
    ))
    @.$("#account-settings-menu").after(Haml.render(@support_block(),
      locals:
        translate: @translate
    ))
    $("#app").html(@el)
    return @
