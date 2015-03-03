class App.Account extends Backbone.Model
  defaults:
    firstname: ""
    lastname: ""
    phone_number: ""
    zip_code: ""
    city: ""

  url: ->
    base = "/account"
    params = $.param({reason: @.reason}) if @.unsuscribe
    base += "?#{params}" if params != undefined
    return base