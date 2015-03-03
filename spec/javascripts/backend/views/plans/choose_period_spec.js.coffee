describe 'App.Views.Plans.ChoosePeriod', ->
  beforeEach ->
    App.Views.Plans.ChoosePeriod.prototype.template = JST['app/assets/javascripts/backend/templates/plans/choose_period']

    @plan = new Backbone.Model
      monthly_price: 2
      yearly_price: 18
    @translate = new Backbone.Model
      views:
        subscription:
          choose_formula: ""
          label_month_formula_html: ""
          label_year_formula_html: ""
          trial_period_without_engagement: ""
          free_setup: ""
          x_months_free: "%{months} mois gratuits, économisez %{saving} €"

    $("<div id='modal'></div>").appendTo("body")

    @view = new App.Views.Plans.ChoosePeriod(plan: @plan, translate: @translate.toJSON(), checkout_url: "")

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'should binds on #modal element', ->
      expect($(@view.el)).toBe("#modal")

    it "renders immediately", ->
      @view.initialize(plan: @plan, translate: @translate.toJSON(), checkout_url: "")
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
    it 'should handle correct events', ->
      expect(@view.events).toEqual
        "submit form" : "checkout_subscription"
        "click input[type=radio]" : "change_period"

    describe 'when a period is chosen', ->
      beforeEach ->
        $("#period_year").click()

      it 'should updates call-to-action', ->
        expect($(".call-to-action p:first-child")).toHaveText "3 mois gratuits, économisez 6 €"
