class App.Collections.Plans extends Backbone.Collection
  model: App.Plan

  url: ->
    return "/plans"

