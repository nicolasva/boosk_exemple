describe "App.Views.Checkout.Success", ->
  beforeEach ->
    App.Views.Checkout.Success.prototype.template = JST["app/assets/javascripts/facebook/templates/checkout/success"]

    @translate = new Backbone.Model({"views": {"frontend": {"checkout": {"success": {"purchase": "purchase","thank_visiting": "thank visiting"}}}},"ok": "ok"})
 
    @translateStub = sinon.stub(App, "Translate").returns(@translate)
    @fetchTranslateStub = sinon.stub(@translate, 'fetch').yieldsTo('success', @translate)
    
    @ViewsCheckoutSuccess = new App.Views.Checkout.Success({translate: @translate})

  afterEach ->
    @translateStub.restore()
    @fetchTranslateStub.restore()

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@ViewsCheckoutSuccess, 'render')

    afterEach ->
      @renderStub.restore()

    it "binds on '#modal' element", ->
      expect(@ViewsCheckoutSuccess.$el.selector).toEqual("#modal")

    it "renders immediately", ->
      @ViewsCheckoutSuccess.initialize
        translate: @translate
      expect(@renderStub).toHaveBeenCalledOnce()

  describe "rendering", ->
    beforeEach ->
      sinon.spy(Haml, 'render')
      sinon.spy(@ViewsCheckoutSuccess, 'template')
      @ViewsCheckoutSuccess.render()

    afterEach ->
      Haml.render.restore()
      @ViewsCheckoutSuccess.template.restore()

    it "calls template method", ->
      expect(@ViewsCheckoutSuccess.template).toHaveBeenCalledOnce()
      expect(@ViewsCheckoutSuccess.template).toHaveBeenCalledWithExactly()

  describe "events", ->
    it "handles correct events", ->
      expect(@ViewsCheckoutSuccess.events).toEqual
        "click #valid_order" : "close_modal"
