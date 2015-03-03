describe 'App.Views.Accounts.Edit', ->
  beforeEach ->
    App.Views.Accounts.Edit.prototype.template = JST['app/assets/javascripts/backend/templates/accounts/edit']
    App.Views.Accounts.Edit.prototype.account_settings_menu = JST['app/assets/javascripts/backend/templates/shared/account_settings_menu']
    App.Views.Accounts.Edit.prototype.support_block = JST['app/assets/javascripts/backend/templates/shared/support_block']

    @translate = new Backbone.Model()
    @translateStub = sinon.stub(App, 'Translate').returns(@translate)

    @account = new Backbone.Model()
    @accountStub = sinon.stub(App, 'Account').returns(@account)

    @geographicRegions = new Backbone.Model()
    @geographicRegionsStub = sinon.stub(App.Collections, 'GeographicRegions').returns(@geographicRegions)

    @fetchTranslateStub = sinon.stub(@translate, 'fetch').yieldsTo('success', @translate)
    @fetchAccountStub = sinon.stub(@account, 'fetch').yieldsTo('success', @account)
    @fetchGeographicRegionsStub = sinon.stub(@geographicRegions, 'fetch').yieldsTo('success', @geographicRegions)

    @zones = new Backbone.Collection(new Backbone.Model(zone_members_codes: ["FR"]))
    @view = new App.Views.Accounts.Edit(zones: @zones)

  afterEach ->
    @fetchTranslateStub.restore()
    @fetchAccountStub.restore()
    @fetchGeographicRegionsStub.restore()
    @translateStub.restore()
    @accountStub.restore()
    @geographicRegionsStub.restore()

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()
 
    it 'creates a section element', ->
      expect(@view.el.nodeName).toEqual('SECTION')

    it 'renders immediately', ->
      @view.initialize(zones: @zones)
      expect(@renderStub).toHaveBeenCalledOnce()

  describe 'rendering', ->
    beforeEach ->
      sinon.spy(Haml, 'render')
      sinon.spy(@view, 'template')
      @view.render()

    afterEach ->
      Haml.render.restore()
      @view.template.restore()

    it 'returns the view object', ->
      expect(@view.render()).toEqual(@view)

    it 'calls template method', ->
      expect(@view.template).toHaveBeenCalledOnce()
      expect(@view.template).toHaveBeenCalledWithExactly()

    it 'calls Haml render method', ->
      expect(Haml.render).toHaveBeenCalledThrice()

    it 'fetches translations', ->
      expect(@fetchTranslateStub).toHaveBeenCalledTwice()

    it 'fetches account data', ->
      expect(@fetchAccountStub).toHaveBeenCalledTwice()

    it 'fetches geograhic regions', ->
      expect(@fetchGeographicRegionsStub).toHaveBeenCalledTwice()

  describe 'events', ->

    it 'handles form submission event', ->
      expect(@view.events['submit #edit_account_form']).toEqual('update')