class App.Views.Panel.SetAttributesAfterAction extends Backbone.View
  initialize: (options) ->
    @render()

  render: ->
    $(".content").animate
      "left": "0%", 
      500
    link_origin = $("#panel_taxonomies").children().first().children().first().children().first()
    new_link_show_taxonomies = link_origin.attr("href", "#/taxonomies")
