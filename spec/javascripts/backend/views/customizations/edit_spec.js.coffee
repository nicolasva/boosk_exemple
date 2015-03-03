describe 'App.Views.Customizations.Edit', ->
  beforeEach ->
    App.Views.Customizations.Edit.prototype.template = JST['app/assets/javascripts/backend/templates/customizations/edit']
    App.Views.Customizations.Edit.prototype.store_settings_menu = JST['app/assets/javascripts/backend/templates/shared/store_settings_menu']
    App.Views.Customizations.Edit.prototype.support_block = JST['app/assets/javascripts/backend/templates/shared/support_block']

    @translate = new Backbone.Model
    @shop = new Backbone.Model
    @customization = new Backbone.Model

    @previewShopStub = sinon.stub(App.Views.Shops, 'Preview').returns(new Backbone.View())
    @uploadPictureStub = sinon.stub(App.Libs, 'UploadPicture').returns(new Backbone.View())


    @view = new App.Views.Customizations.Edit
      translate: @translate
      shop: @shop
      customization: @customization
      wizard: false

  afterEach ->
    @previewShopStub.restore()
    @uploadPictureStub.restore()

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'creates a section element', ->
      expect(@view.el.nodeName).toEqual('SECTION')

    it 'renders immediately', ->
      @view.initialize
        translate: @translate
        shop: @shop
        customization: @customization
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
      expect(@view.template).toHaveBeenCalledWithExactly(@customization.toJSON())

    it 'calls Haml render method', ->
      expect(Haml.render).toHaveBeenCalledThrice()

  describe 'events', ->
    it 'should handle correct events', ->
      expect(@view.events).toEqual
        "click .back": "add_back_class"
        "submit #edit_shop_customization": "save"
        "click #edit_shop_customization :checkbox" : "toggleAttribute"
        "change .pick_color": "changeCustomizationAttribute"
        "change #nb_products_grid": "changeNbProductsGrid"
        "click .remove-attachment" : "removeAttachment"
        "click .disabled-customization + button": "upgrade_plan"