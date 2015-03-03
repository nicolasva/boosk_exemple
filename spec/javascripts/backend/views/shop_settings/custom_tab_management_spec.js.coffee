describe 'App.Views.ShopSettings.CustomTabManagement', ->
  beforeEach ->
    App.Views.ShopSettings.CustomTabManagement.prototype.template = JST['app/assets/javascripts/backend/templates/shop_settings/custom_tab_management']
    @translate = new Backbone.Model
      views:
        status:
          edit:
            help_block_facebook_custom_tab_image: ""
            help_block_facebook_custom_tab_name: ""
    window.FB =
      api: sinon.stub().yields({data: [{image_url: "", name: "test"}]})

  describe 'instantiation', ->
    beforeEach ->
      @shop = new Backbone.Model()
      @view = new App.Views.ShopSettings.CustomTabManagement(translate: @translate.toJSON(), shop: @shop)
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'should create a DIV element', ->
      expect(@view.el.tagName).toEqual("DIV")

    it "renders immediately", ->
      @view.initialize(translate: @translate.toJSON(), shop: @shop)
      expect(@renderStub).toHaveBeenCalledOnce()

  describe 'rendering', ->
    beforeEach ->
      @shop = new Backbone.Model(fan_page_id: "123456")
      @view = new App.Views.ShopSettings.CustomTabManagement(translate: @translate.toJSON(), shop: @shop)
      sinon.spy(Haml, 'render')
      sinon.spy(@view, 'template')
      @uploadPictureViewStub = sinon.stub(App.Libs, 'UploadPicture')
      @view.render()

    afterEach ->
      Haml.render.restore()
      @view.template.restore()
      @uploadPictureViewStub.restore()

    it 'returns the view object', ->
      expect(@view.render()).toEqual(@view)

    it 'calls template method', ->
      expect(@view.template).toHaveBeenCalledOnce()
      expect(@view.template).toHaveBeenCalledWithExactly()

    it 'calls Haml render method', ->
      expect(Haml.render).toHaveBeenCalledOnce()

    it 'creates an upload picture view', ->
      expect(@uploadPictureViewStub).toHaveBeenCalledOnce()

  describe 'events', ->
    beforeEach ->
      @shop = new Backbone.Model(fan_page_id: "123456")
      @view = new App.Views.ShopSettings.CustomTabManagement(translate: @translate.toJSON(), shop: @shop)
      $(@view.el).appendTo("body")

    afterEach ->
      $(@view.el).remove()

    it 'handle correct UI events', ->
      expect(@view.events).toEqual
        "click #custom_tab_name_link": "editCustomTabName"
        "blur #custom_tab_name": "updateCustomTabName"

    describe "when tab name link is clicked", ->
      beforeEach ->
        $('#custom_tab_name_link').click()

      it "hides tab name link", ->
        expect($("#custom_tab_name_link")).toBeHidden()

      it "shows an input field", ->
        expect($("#custom_tab_name")).toBeVisible()

      it "updates input field value with current tab name value", ->
        expect($("#custom_tab_name")).toHaveValue("test")

    describe "when tab name input field looses focus", ->
      beforeEach ->
        $('#custom_tab_name_link').click()
        $("#custom_tab_name").val("test2")
        $("#custom_tab_name").blur()

      it "hides tab name input field", ->
        expect($("#custom_tab_name")).toBeHidden()

      it "shows tab name link", ->
        expect($("#custom_tab_name_link")).toBeVisible()

      it "updates tab name link with new value", ->
        expect($("#custom_tab_name_link")).toHaveText(/test2/)

    describe "when 'fan_page_id' attribute changes on shop model", ->
      beforeEach ->
        @shop.set(fan_page_id: "987654321")

      it "updates the view", ->
        expect($("#custom_tab_name_link")).toHaveText(/Boosket Shop/)