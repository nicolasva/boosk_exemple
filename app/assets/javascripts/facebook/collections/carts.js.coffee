class App.Collections.Carts extends Backbone.Collection
  model: App.Cart

  url: ->
    base = "/#{App.ui()}/shops/#{App.current_shop}/carts"
    params = $.param({country: @.buyer_country, state: @.buyer_state}) if @.buyer_country != undefined
    base += "?#{params}" if params != undefined
    return base

  parse: (attributes) ->
    @.total = attributes.total
    @.total_with_shipping = attributes.total_with_shipping
    @.shipping = attributes.shipping
    @.is_deliverable = attributes.is_deliverable
    return attributes.items
