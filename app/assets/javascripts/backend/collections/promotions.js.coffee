class App.Collections.Promotions extends Backbone.Collection
  model: App.Promotion

  url: ->
    "/shops/#{App.current_shop}/promotions"

  bulk_destroy_url: ->
    "/shops/#{App.current_shop}/promotions/destroy/all"

  hasSelected: ->
    @some (promotion) ->
      promotion.isSelected()
  selected: ->
    @filter (promotion) ->
      promotion.isSelected()