App.Views.Orders ||= {}

class App.Views.Orders.Show extends Backbone.View
  el: '#app'
  template: JST["backend/templates/orders/show"]

  events:
    "change select[name='action']": "change_status"

  initialize: (options) ->
    @order = options.order
    @translate = options.translate.toJSON()
    @actions =
      0:
        action: @translate.views.order.status.paid.action
        display: @translate.views.order.status.paid.display
      1:
        action: @translate.views.order.status.shipped.action
        display: @translate.views.order.status.shipped.display
      2:
        action: @translate.views.order.status.delivered.action
        display: @translate.views.order.status.delivered.display
      3:
        action: @translate.views.order.status.closed.action
        display: @translate.views.order.status.closed.display
      4:
        action: @translate.views.order.status.canceled.action
        display: @translate.views.order.status.canceled.display
    @render()

  change_status: (e) ->
    e.preventDefault()
    e.stopPropagation()
    status = $(e.target).val()
    self = @
    if status isnt 'paid' and status isnt 'closed'
      msg = @translate.views.order.warning.remove_confirm.one
      msg += '<br>' + @translate.views.order.info_change_status
    else
      msg = @translate.views.order.warning.remove_confirm.one
    @popup = new App.Views.Popup
      translate: @translate
      message: msg
      el: $('#modal .modal-body')
      mode: "confirm"
      callback: ->
        App.eventsDispatcher.trigger 'startLoading'
        self.order.change_status(self.order,status,
          success: (model, order) ->
            App.eventsDispatcher.trigger 'loadingComplete'
            new App.Views.Notice
              message: self.translate.views.order.notice.change_status_successfully
              type: 'success'
              size: 'large'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
        )


  render: ->
    order = @order.toJSON()

    total_ht = _.reduce(order.line_items, (a,b) ->
      return a + (b.quantity * b.price_ht)
    , 0)

    tax = _.reduce(order.line_items, (a,b) ->
      return a + (b.quantity * b.price_ttc)
    , 0) - total_ht

    $(@el).html(Haml.render(@template(), { locals: {
      order: order
      contact: order.contact
      address: order.contact.addresses[0]
      email: order.contact.emails[0].email
      translate: @translate
      actions: @actions
      total_ht: total_ht
      tax: tax
    } }))
    return @

  close: ->
    $(@el).unbind()
    $(@el).empty()