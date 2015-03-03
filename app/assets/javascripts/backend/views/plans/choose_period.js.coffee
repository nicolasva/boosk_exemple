class App.Views.Plans.ChoosePeriod extends Backbone.View
  template: JST["backend/templates/plans/choose_period"]

  el: "#modal"

  events:
    "submit form" : "checkout_subscription"
    "click input[type=radio]" : "change_period"

  initialize: (options) ->
    @plan = options.plan
    @translate = options.translate
    @checkout_url = options.checkout_url
    @period = "month"
    @render()

  change_period: (e) ->
    @period = $(e.target).val()
    if @period is "month"
      @.$(".call-to-action p").html(@translate.views.subscription.trial_period_without_engagement)
      @.$(".call-to-action p.free_setup").html(@translate.views.subscription.free_setup)
    else
      call_to_action = @translate.views.subscription.x_months_free
      saving = 12*@plan.get('monthly_price') - @plan.get('yearly_price')
      months_saved = Math.round(saving/@plan.get('monthly_price'))
      call_to_action = call_to_action.replace(/%{months}/, months_saved)
      call_to_action = call_to_action.replace(/%{saving}/, saving)
      @.$(".call-to-action p").html(call_to_action)
      @.$(".call-to-action p.free_setup").html(@translate.views.subscription.free_setup)

  checkout_subscription: (e) ->
    e.preventDefault()
    e.stopPropagation()
    window.location = "#{@checkout_url}?plan=#{@plan.get('name')}&period=#{@period}"

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      plan: @plan.toJSON()
      translate: @translate
    } }))
    $(@el).addClass('modal-subscription-formula')
    $(@el).modal('show')
    $(@el).on 'hide', ->
       $('#modal').removeClass('modal-subscription-formula')
    return @

