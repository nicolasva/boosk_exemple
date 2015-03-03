describe 'App.Views.Plans.BoxUpgrade', ->
  beforeEach ->
    App.Views.Plans.BoxUpgrade.prototype.template = JST['app/assets/javascripts/backend/templates/plans/box_upgrade']

    @translate = new Backbone.Model(month: "", or: "", year: "", upgrade: "")
    @account = new Backbone.Model(plan_id: 1)
    @plan1 = new Backbone.Model(id: 1, name: "Plan 1", monthly_price: 0, yearly_price: 0)
    @plan2 = new Backbone.Model(id: 2, name: "Plan 2", monthly_price: 0, yearly_price: 0)

    @plans = new Backbone.Collection([@plan1, @plan2])

    @translateStub = sinon.stub(App, 'Translate').returns(@translate)
    @accountStub = sinon.stub(App, 'Account').returns(@account)
    @plansStub = sinon.stub(App.Collections, 'Plans').returns(@plans)

    @fetchTranslateStub = sinon.stub(@translate, 'fetch').yieldsTo('success', @translate)
    @fetchAccountStub = sinon.stub(@account, 'fetch').yieldsTo('success', @account)
    @fetchPlansStub = sinon.stub(@plans, 'fetch').yieldsTo('success', @plans)

    $("<div id='modal'></div>").appendTo("body")

    @view = new App.Views.Plans.BoxUpgrade(message: "")

  afterEach ->
    $("#modal").remove()

    @fetchPlansStub.restore()
    @fetchAccountStub.restore()
    @fetchTranslateStub.restore()
    @plansStub.restore()
    @accountStub.restore()
    @translateStub.restore()

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'should binds to #modal', ->
      expect(@view.$el.selector).toEqual("#modal")

    it "renders immediately", ->
      @view.initialize
        message: ""
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
      expect(Haml.render).toHaveBeenCalledOnce()

  describe 'events', ->
    it 'does not handle any event', ->
      expect(@view.events).toBeUndefined()