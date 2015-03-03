describe 'App.Views.Payment.Edit', ->
  beforeEach ->
    App.Views.Payment.Edit.prototype.template = JST['app/assets/javascripts/backend/templates/payment/edit']
    App.Views.Payment.Edit.prototype.store_settings_menu = JST['app/assets/javascripts/backend/templates/shared/store_settings_menu']
    App.Views.Payment.Edit.prototype.support_block = JST['app/assets/javascripts/backend/templates/shared/support_block']

    $("<div id='app'></div>").appendTo("body")

    @translate = new Backbone.Model
      back: ""
      next: ""
      update: ""
      views:
        payment:
          edit:
            h2_info: ""
            help_block_paypal: ""
      activerecord:
        attributes:
          shop:
            paypal_account: ""
    @shop = new Backbone.Model()
    @account = new Backbone.Model()

    @view = new App.Views.Payment.Edit
      translate: @translate
      model: @shop
      account: @account
      wizard: true

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'should create a SECTION element', ->
      expect(@view.el.tagName).toEqual("SECTION")

    it "renders immediately", ->
      @view.initialize
        translate: @translate
        model: @shop
        account: @account
        wizard: false
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
    it 'handles correct events', ->
      expect(@view.events).toEqual
        "click .back": "add_back_class"
        "submit form": "save"

    describe 'when .back button is clicked', ->
      it "should add a 'back-action' class to form", ->
        $(".back").click()
        expect($("#store-settings form").hasClass("back-action")).toBeTruthy()

    describe 'when form is submitted', ->
      beforeEach ->
        @saveShopStub = sinon.stub(@shop, "save")
        $("form").submit()

      afterEach ->
        @saveShopStub.restore()

      it "should save shop", ->
        expect(@saveShopStub).toHaveBeenCalledOnce()