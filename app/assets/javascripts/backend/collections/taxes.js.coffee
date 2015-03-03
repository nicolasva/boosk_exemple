class App.Collections.TaxRates extends Backbone.Collection
  model: App.TaxRate

  bulk_destroy_url: ->
    "/shops/#{App.current_shop}/tax_rates/destroy/all"

  url: ->
    base = "/shops/#{App.current_shop}/tax_rates"
