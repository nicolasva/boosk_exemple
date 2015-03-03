class App.GeographicRegion extends Backbone.Model

  parse: (region) ->
    @id = region.code
    return region