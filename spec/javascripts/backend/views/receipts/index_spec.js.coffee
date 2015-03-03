describe 'App.Views.Receipts.Index', ->
  beforeEach ->
    App.Views.Receipts.Index.prototype.template = JST['app/assets/javascripts/backend/templates/receipts/index']
    App.Views.Receipts.Index.prototype.account_settings_menu = JST["app/assets/javascripts/backend/templates/shared/account_settings_menu"]
    App.Views.Receipts.Index.prototype.support_block = JST["app/assets/javascripts/backend/templates/shared/support_block"]

    $("<div id='app'></div>").appendTo("body")
    @translate = new Backbone.Model
      views:
        receipt:
          index:
            h2: ""
            you_have_not_yet_receipt: ""
    @view = new App.Views.Receipts.Index(translate: @translate)

  afterEach ->
    $("#app").remove()

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'should create a SECTION element', ->
      expect(@view.el.tagName).toEqual("SECTION")

    it "renders immediately", ->
      @view.initialize(translate: @translate)
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

  describe 'events', ->
    it 'should not handle any event', ->
      expect(@view.events).toBeUndefined()