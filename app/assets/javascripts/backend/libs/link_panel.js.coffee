class App.Libs.LinkPanel extends Backbone.View
  initialize: (options) ->
    self = @
    $(document).ready ->
      self.set_link_menu()

    $(window).bind 'hashchange', ->
      $('.panel').removeAttr("style")
      $(".panel").each (key, val) ->
        class_css = $(val).attr("class")
        regex = new RegExp("^.{1,}_select$")
        if regex.test(class_css)
          class_origin = class_css.split("_")[0]
          $(val).attr("class", class_origin)
      self.set_link_menu()

  set_link_menu: ->
    location_hash = window.location.hash+"/"
    regex = new RegExp("^.{1,}(products|orders|customizations|analytics|dashboard|settings).{1,}$")
    controller = location_hash.scan(regex)[0][0]
    controller = "storesettings" if controller == "settings"
    class_origin = "."+controller
    class_to_set = "panel "+controller+"_select"
    $(class_origin).attr('style', "color:black;")
    $(class_origin).attr("class", class_to_set)

