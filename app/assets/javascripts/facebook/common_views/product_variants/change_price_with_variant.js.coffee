class App.CommonViews.ProductVariants.ChangePriceWithVariant extends Backbone.View
  el: ".price"

  initialize: (options) ->
    @price = options.price
    @render()

  render: ->
    $(@el).html("#{@price} #{App.getCookie('front_shop_devise')}") unless parseFloat($(".price").html()) == parseFloat(@price)
