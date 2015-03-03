class App.Views.OptionTypes.OptionTypesSelect extends Backbone.View
  el: ".form_select_option"
  template: JST["mobile/templates/option_types/option_types_select"]

  initialize: (options) ->
    @model_error = options.model_error
    @render()

  render: ->
    $("#cart_item_option_type").css("border-color", "#fe6903") 
    $(@el).prepend(Haml.render(@template(), {locals: { model_error: @model_error}}))
    $('html, body').animate({scrollTop: $(".container").height()}, 'slow') 

