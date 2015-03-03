class App.Views.Plans.BoxUpgrade extends Backbone.View
  template: JST["backend/templates/plans/box_upgrade"]

  el: "#modal"

  initialize: (options) ->
    @translate = new App.Translate
    @account = new App.Account
    @plans = new App.Collections.Plans
    @message = options.message
    self = @
    App.eventsDispatcher.trigger 'startLoading'
    self.translate.fetch
      success: ->
        self.account.fetch
          success: ->
            self.plans.fetch
              success: ->
                self.render()
                App.eventsDispatcher.trigger 'loadingComplete'
              error: ->
                App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  render: ->
    $(@el).find('h3').hide()
    $(@el).find('.modal-body').html(Haml.render(@template(), { locals: {
      plans: @plans.toJSON()
      user_plan: @plans.get(@account.get('plan_id')).toJSON()
      translate: @translate.toJSON()
      message: @message
    } }))
    $(@el).addClass('modal-upgrade-plan')
    $(@el).modal('show')
    self = @
    $(@el).on 'hide', (e) ->
      $(self.el).removeClass('modal-upgrade-plan')
      $(self.el).find('h3').show()
    return @
