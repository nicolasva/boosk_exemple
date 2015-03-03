class App.Views.Listshop extends Backbone.View
  el: '#shop_lists'
  template: JST["backend/templates/shops/select_option_shops_list"]

  initialize: (options) ->
    @shops = options.shops
    @current_shop = @shops.get(App.current_shop)
    @render()

  events:
    "change #shop_selected_id" : "selected_shop"

  render: ->
    shop_id = App.current_shop
    $(this.el).html(Haml.render(@template(), { locals: { shops: @shops.toJSON(), shop_id: shop_id} }))
    $('.chzn-select').chosen()

  selected_shop: (event) ->
    id = $(event.target).attr('value')
    App.current_shop = id
    @current_shop = @shops.get(id)
    @current_shop.fetch
      success: (current_shop) ->
        Backbone.history.stop()
        Backbone.history.start()
        Backbone.history.navigate "#/dashboard", true
