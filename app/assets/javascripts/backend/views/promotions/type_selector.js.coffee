class App.Views.Promotions.TypeSelector extends Backbone.View
  template: JST['backend/templates/promotions/type_selector']

  initialize: ->
    @translate = @options.translate

  render: ->
    @.$el.html(Haml.render(@template(), { locals: { translate: @translate } }))
    return @
