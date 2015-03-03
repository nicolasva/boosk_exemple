describe "Checkout CancelOrder", ->
  beforeEach ->
    App.Views.Checkout.CancelOrder.prototype.template = JST["app/assets/javascripts/facebook/templates/shop/show"]
    
    @CancelOrderView = new App.Views.Checkout.CancelOrder()

  describe "instantiation", ->
    beforeEach ->
      @renderStub = sinon.stub(@CancelOrderView, 'render')

    afterEach ->
      @renderStub.restore()

    it "binds on '#modal' element", ->
      expect(@CancelOrderView.$el.selector).toEqual('#modal')

    it "renders immediately", ->
      @CancelOrderView.initialize()
      expect(@renderStub).toHaveBeenCalledOnce()

  describe "events", ->
    it "handles correct events", ->
      expect(@CancelOrderView.events).toEqual
        "click #valid_order" : "close_modal" 
