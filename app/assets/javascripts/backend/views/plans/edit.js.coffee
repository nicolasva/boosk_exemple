class App.Views.Plans.Edit extends Backbone.View
  template: JST["backend/templates/plans/edit"]
  account_settings_menu: JST["backend/templates/shared/account_settings_menu"]
  support_block: JST["backend/templates/shared/support_block"]

  tagName: "section"
  id: "account-settings"
  className: "container-fluid"

  events:
    "click .unsuscribe": "unsuscribe"

  initialize: (options) ->
    @translate = options.translate.toJSON()
    @account = options.account
    @plans = options.plans
    @render()

  unsuscribe: (e) ->
    self = @
    @popup.close() if @popup != undefined
    @popup = new App.Views.Popup
      translate: @translate
      message: @translate.views.plan.edit.warning.confirm_unsuscribe
      el: $('#modal .modal-body')
      tpl: JST["backend/templates/plans/unsuscribe"]
      mode: "confirm"
      callback: ->
        self.account.unsuscribe = true
        self.account.reason = $('#unsuscribe input[name="reason"]:checked').attr('value')
        App.eventsDispatcher.trigger 'startLoading'
        self.account.destroy
          success: ->
            App.eventsDispatcher.trigger 'loadingComplete'
            window.location.href = "/users/login"
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      plans: @plans.toJSON()
      user_plan: @plans.get(@account.get('plan_id')).toJSON()
      translate: @translate
    } }))
    @.$("#account-settings-menu").html(Haml.render(@account_settings_menu(),
      locals:
        translate: @translate
        active: "plans"
    ))
    @.$("#account-settings-menu").after(Haml.render(@.support_block(),
      locals:
        translate: @translate
    ))
    $("#app").html(@el)
    return @
