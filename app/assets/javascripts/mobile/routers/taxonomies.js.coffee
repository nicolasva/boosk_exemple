class App.Routers.Taxonomies extends Backbone.Router
  routes:
    "/taxonomies": "taxonomies"
    "/taxonomies/hide": "taxonomies_hide"

  taxonomies: ->
    $(".content").animate
      "left": "88%", 
      500
    $("#panel_taxonomies").attr("href", "#/taxonomies/hide")

  taxonomies_hide: ->
    $(".content").animate
      "left": "0%", 
      500
    $("#panel_taxonomies").attr("href", "#/taxonomies")
