App.Views.Orders ||= {}

class App.Views.Orders.Index extends Backbone.View
  template: JST["backend/templates/orders/index"]

  events:
   "click .select-all": "select_all_orders"
   "change select[name='action']": "change_status"


  initialize: (options) ->
    @orders = options.orders
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


  change_status: (e) ->
    e.preventDefault()
    e.stopPropagation()
    orders = @get_orders_selected($('.order-selected'))
    status = $(e.target).val()
    self = @
    if _.isEmpty(orders)
      @confirm = new App.Views.Popup
        translate: @translate
        message: @translate.views.order.warning.select_order_before
        el: $('#modal .modal-body')
        mode: "alert"
    else
      App.eventsDispatcher.trigger 'startLoading'
      @orders.change_status(orders,status,
        success: (models, orders) ->
          for order in models
            el = $("tr[data-id=#{order.id}]").find('.label')
            $(el).removeClass("label-#{order.get('workflow_state')}")
            order.set(workflow_state: status)
            $(el).addClass("label-#{status}")
            $(el).html(
              _.find(self.translate.views.order.status, (s) ->
                return s.action == order.get('workflow_state')
              ).display
            )
          App.eventsDispatcher.trigger 'loadingComplete'
          new App.Views.Notice
            message: self.translate.views.order.notice.change_status_successfully
            type: 'success'
            size: 'large'
        error: ->
          App.eventsDispatcher.trigger 'loadingComplete'
      )
    $('.action option:first-child').attr('selected','selected')


  select_all_orders: (e) ->
    if $(e.target).is(':checked')
      for order in $('.order-selected')
        order.checked = true
    else
      for order in $('.order-selected')
        order.checked = false

  get_orders_selected: (orders) ->
    orders_selected = []
    for order in orders
      if $(order).is(':checked')
        id = $(order).parents('tr').attr('data-id')
        orders_selected.push(@orders.get(id))
    return orders_selected

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      orders: @orders.toJSON()
      translate: @translate
      actions: @actions
    } }))
    return this

