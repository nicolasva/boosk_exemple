class App.Views.Receipts.Index extends Backbone.View
  template: JST["backend/templates/receipts/index"]
  account_settings_menu: JST["backend/templates/shared/account_settings_menu"]
  support_block: JST["backend/templates/shared/support_block"]

  tagName: "section"
  id: "account-settings"
  className: "container-fluid"


  initialize: (options) ->
    @translate = options.translate.toJSON()
    @render()

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      translate: @translate
    } }))
    @.$("#account-settings-menu").html(Haml.render(@account_settings_menu(),
      locals:
        translate: @translate
        active: "receipts"
    ))
    @.$("#account-settings-menu").after(Haml.render(@.support_block(),
      locals:
        translate: @translate
    ))
    $("#app").html(@el)
    return @
