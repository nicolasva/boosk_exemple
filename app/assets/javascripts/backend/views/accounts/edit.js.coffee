App.Views.Accounts ||= {}

class App.Views.Accounts.Edit extends Backbone.View
  template: JST["backend/templates/accounts/edit"]
  account_settings_menu: JST["backend/templates/shared/account_settings_menu"]
  support_block: JST["backend/templates/shared/support_block"]

  form_id: '#edit_account_form'

  tagName: "section"
  id: "account-settings"
  className: "container-fluid"

  events:
    "submit #edit_account_form": "update"

  initialize: (options) ->
    super(options)
    @translate = new App.Translate
    @zones = options.zones
    @account = new App.Account
    @geographic_regions = new App.Collections.GeographicRegions
    @render()

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()
    self = @
    data = $(@form_id).toJSON()
    if not data.user.password and not data.user.password_confirmation
      delete data.user.password
      delete data.user.password_confirmation
    App.eventsDispatcher.trigger 'startLoading'
    @account.save(data,
      success: (model, response) =>
        App.eventsDispatcher.trigger 'loadingComplete'
        new App.Views.Notice(message: self.translate.toJSON().views.account.notice.updated_successfully, type: 'success')
      error: (model, response) =>
        App.eventsDispatcher.trigger 'loadingComplete'
        errors = if response.status is 422 then $.parseJSON(response.responseText) else response
        new App.Views.Notice(message: errors, type: 'error', el: '#notice' )
    )

  render: ->
    self = @
    @translate.fetch
      success: (model, response) ->
        self.account.fetch
          success: (model, response) ->
            self.geographic_regions.fetch
              success: (collection, response) =>
                if self.account.attributes.address != undefined
                  code = self.account.attributes.address.country
                else
                  code = self.zones.toJSON()[0].zone_members_codes[0]
                $(self.el).html(Haml.render(self.template(), { locals: {
                  account: self.account.toJSON()
                  translate: self.translate.toJSON()
                  regions: self.geographic_regions.toJSON()
                  account_code: code
                } }))
                self.$("#account-settings-menu").html(Haml.render(self.account_settings_menu(),
                  locals:
                    translate: self.translate.toJSON()
                    active: "general"
                ))
                self.$("#account-settings-menu").after(Haml.render(self.support_block(),
                  locals:
                    translate: self.translate.toJSON()
                ))
                $("#app").html(self.el)
                self.$('#user_country').select2
                  minimumInputLength: 2
                  allowClear: true
                  formatNoMatches: (term) ->
                    self.translate.toJSON().views.select2.no_matches
                  formatInputTooShort: (term, minLength) ->
                    self.translate.toJSON().views.select2.input_too_short.replace /%{nb}/, minLength - term.length
                  matcher: (term, text) ->
                    text.latinize().toUpperCase().indexOf(term.latinize().toUpperCase())>=0
                App.eventsDispatcher.trigger 'loadingComplete'
              error: ->
                App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'        
    return @
