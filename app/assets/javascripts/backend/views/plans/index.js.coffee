class App.Views.Plans.Index extends Backbone.View
  template: JST["backend/templates/plans/index"]
  el: '#app'

  events:
    "click .choose": "choose_plan"

  initialize: (options) ->
    @plans = options.plans
    @translate = options.translate.toJSON()
    @account = options.account
    @render()

  choose_plan: (e) ->
    if _.isString(e)
      plan = @plans.get(e)
      checkout_url = $('.plan').find("a[data-plan='#{e}']").attr('href')
    else
      e.preventDefault()
      e.stopPropagation()
      plan = @plans.get($(e.target).attr('data-plan'))
      checkout_url = $(e.target).attr('href')
    if App.getCookie('have_coupon') == "1"
      view = new App.Views.Plans.Coupon
        plan: plan
        translate : @translate
        checkout_url: checkout_url
    else if App.getCookie('without_cb') == "1" or plan.get('name') is 'start'
      window.location = "#{checkout_url}?plan=#{plan.get('name')}"
    else
      view = new App.Views.Plans.ChoosePeriod
        plan: plan
        translate : @translate
        checkout_url: checkout_url

  render: ->
    user_plan = @plans.get(@account.get('plan_id')).toJSON() if @account.has('plan_id')
    $(@el).html(Haml.render(@template(), { locals: {
      plans: @plans.toJSON()
      translate: @translate
      account: @account.toJSON()
      user_plan: user_plan
    } }))

    $('.popover').css('width', '60% !important')
    $('.help').popover
      trigger: 'hover'

    if getUrlVars()['id'] != undefined
      plan = getUrlVars()['id'].match(/^(.*)\/\#/)[1]
      @choose_plan(plan)

    return @
