describe 'App.Views.Plans.Coupon', ->
  beforeEach ->
    App.Views.Plans.Coupon.prototype.template = JST['app/assets/javascripts/backend/templates/plans/coupon']
    @plan = new Backbone.Model()
    @translate = new Backbone.Model
      newt: ""
      views:
        subscription:
          promo_code: ""
          coupon_code: ""

    $("<div id='modal'></div>").appendTo("body")

    @view = new App.Views.Plans.Coupon
      plan: @plan
      translate: @translate.toJSON()
      checkout_url: ""

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