describe 'App.Views.ShopSettings.Status', ->
  beforeEach ->
    App.Views.ShopSettings.Status.prototype.template = JST['app/assets/javascripts/backend/templates/shop_settings/status']
    App.Views.ShopSettings.Status.prototype.store_settings_menu = JST['app/assets/javascripts/backend/templates/shared/store_settings_menu']
    App.Views.ShopSettings.Status.prototype.support_block = JST['app/assets/javascripts/backend/templates/shared/store_settings_menu']

    @translate = new Backbone.Model
      coming_soon: ""
      back: ""
      next: ""
      update: ""
      views:
        status:
          edit:
            h2: ""
            help_block_facebook: ""
            help_block_facebook_fan_only: ""
            help_block_mobile: ""
      activerecord:
        attributes:
          customization:
            fan_access: ""

    @shop = new Backbone.Model(uuid: "123", facebook_status: "1", mobile_status: "1", google_shopping_status: "1")
    @customization = new Backbone.Model(fan_access: "1")
    @shop_functionnality = new Backbone.Model()

    @fbTabManagementView = new Backbone.View()
    @fbTabManagementViewStub = sinon.stub(App.Views.ShopSettings, 'FacebookTabManagement').returns(@fbTabManagementView)
    @fbTabManagementView.manageFacebookTab = sinon.stub()
    @view  = new App.Views.ShopSettings.Status
      translate: @translate
      shop: @shop
      customization: @customization
      wizard: true
      shop_functionnality: @shop_functionnality
    $("<div id='app'></div>").appendTo("body")

  afterEach ->
    $("#app").remove()
    @fbTabManagementViewStub.restore()

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'should create a SECTION element', ->
      expect($(@view.el)).toBe('section#store-settings.container-fluid')

    it 'renders immediately', ->
      @view.initialize
        translate: @translate
        shop: @shop
        customization: @customization
        wizard: true
        shop_functionnality: @shop_functionnality
      expect(@renderStub).toHaveBeenCalledOnce()

  describe 'rendering', ->
    beforeEach ->
      sinon.spy(Haml, 'render')
      sinon.spy(@view, 'template')

    afterEach ->
      Haml.render.restore()
      @view.template.restore()

    it 'returns the view object', ->
      expect(@view.render()).toEqual(@view)

    it 'calls template method', ->
      @view.render()
      expect(@view.template).toHaveBeenCalledOnce()
      expect(@view.template).toHaveBeenCalledWithExactly()

    it 'calls Haml render method', ->
      @view.render()
      expect(Haml.render).toHaveBeenCalledThrice()

    it 'creates a Facebook tab management view', ->
      @view.render()
      expect(@fbTabManagementViewStub).toHaveBeenCalledTwice()

    it 'appends view to #app element', ->
      @view.render()
      expect($('#app')).toContain($(@view.el))

  describe 'events', ->
    beforeEach ->
      @shopSaveStub = sinon.stub(@shop, 'save')
      @view.render()

    afterEach ->
      @shopSaveStub.restore()

    it 'handles correct UI events', ->
      expect(@view.events).toEqual
        "click .back": "add_back_class"
        "submit form": "save"
        "click .status": "switch_on_off"

    describe "when 'back' button is clicked", ->
      it "adds 'back-action' class to FORM element", ->
        $(".back").click()
        expect($('#store-settings form')).toHaveClass('back-action')

      it 'saves the changes', ->
        $(".back").click()
        expect(@shopSaveStub).toHaveBeenCalledOnce()

    describe "when form is submitted", ->
      it 'saves the changes', ->
        $("form").submit()
        expect(@shopSaveStub).toHaveBeenCalledOnce()

    describe "when 'status' button is clicked", ->
      it 'switches input value', ->
        $('#shop_facebook_status').parent().click()
        expect($('#shop_facebook_status')).toHaveValue("0")

      it 'changes class element', ->
        $('#shop_facebook_status').parent().click()
        expect($('#shop_facebook_status').parent()).toHaveClass("small-off")
