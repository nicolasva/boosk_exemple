class App.Collections.GeographicRegions extends Backbone.Collection
  model: App.GeographicRegion

  url: ->
    return "/dashboard/geographic_regions"
