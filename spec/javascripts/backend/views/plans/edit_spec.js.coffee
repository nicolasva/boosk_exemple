describe 'App.Views.Plans.Edit', ->
  beforeEach ->
    App.Views.Plans.Edit.prototype.template = JST['app/assets/javascripts/backend/templates/plans/edit']
    App.Views.Plans.Edit.prototype.account_settings_menu = JST['app/assets/javascripts/backend/templates/shared/account_settings_menu']
    App.Views.Plans.Edit.prototype.support_block = JST['app/assets/javascripts/backend/templates/shared/support_block']

    $("<div id='app'></div>").appendTo("body")

    @translate = new Backbone.Model
      month: ""
      or: ""
      year: ""
      upgrade: ""
      views:
        plan:
          index:
            h2: ""
          edit:
            unsuscribe: ""
            view_details: ""
            user_suscribtion: ""
            warning:
              confirm_unsuscribe: ""
    @account = new Backbone.Model
      plan_id: 1
    @plan1 = new Backbone.Model(id: 1, name: "Plan 1", monthly_price: 0, yearly_price: 0)
    @plan2 = new Backbone.Model(id: 2, name: "Plan 2", monthly_price: 0, yearly_price: 0)
    @plans = new Backbone.Collection([@plan1, @plan2])

    @view = new App.Views.Plans.Edit(translate: @translate, account: @account, plans: @plans)

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
      @view.initialize(translate: @translate, account: @account, plans: @plans)
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
    it 'should handle correct events', ->
      expect(@view.events).toEqual
        "click .unsuscribe": "unsuscribe"

    describe "when 'unsubscribe' link is clicked", ->
      beforeEach ->
        @popupStub = sinon.stub(App.Views, 'Popup').returns(new Backbone.View())
        $(".unsuscribe").click()

      afterEach ->
        @popupStub.restore()

      it "should display a pop up to confirm the account removal", ->
        expect(@popupStub).toHaveBeenCalledOnce()
