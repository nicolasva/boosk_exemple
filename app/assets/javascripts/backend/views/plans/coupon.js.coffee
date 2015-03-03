class App.Views.Plans.Coupon extends Backbone.View
  template: JST["backend/templates/plans/coupon"]

  el: "#modal"

  events:
    "submit form" : "checkout_subscription"

  initialize: (options) ->
    @plan = options.plan
    @translate = options.translate
    @checkout_url = options.checkout_url
    @period = "month"
    @render()

  checkout_subscription: (e) ->
    e.preventDefault()
    e.stopPropagation()
    window.location = "#{@checkout_url}?plan=#{@plan.get('name')}&period=#{@period}&coupon=#{$('#coupon').val()}"

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

