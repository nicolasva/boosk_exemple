describe 'App.Views.ShopSettings.MenuPreview', ->
  beforeEach ->
    App.Views.ShopSettings.MenuPreview.prototype.template = JST['app/assets/javascripts/backend/templates/shop_settings/menu_preview']

    @taxon1 = new Backbone.Model(id: 1)
    @taxon2 = new Backbone.Model(id: 2)
    @taxon3 = new Backbone.Model(id: 3)
    @taxons = new Backbone.Collection()
    @taxons.root = sinon.stub().returns(@taxon1)
    @taxon1.isLeaf = sinon.stub().returns(true)
    @translate = new Backbone.Model
      views:
        cart:
          empty: ""
        menu:
          home: ""

    @view = new App.Views.ShopSettings.MenuPreview(taxons: @taxons, translate: @translate.toJSON())

    $(@view.el).appendTo("body")

  afterEach ->
    $(@view.el).remove()

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'creates a SECTION element', ->
      expect($(@view.el)).toBe('section')

    it 'renders immediately', ->
      @view.initialize(taxons: @taxons, translate: @translate.toJSON())
      expect(@renderStub).toHaveBeenCalledOnce()

  describe 'rendering', ->
    beforeEach ->
      sinon.spy(Haml, 'render')
      sinon.spy(@view, 'template')
      @menuItemView = new Backbone.View()
      @menuItemView.render = () ->
        @el = document.createElement('li')
        return @
      sinon.spy(@menuItemView, 'render')
      @menuItemStub = sinon.stub(App.Views.ShopSettings, 'MenuItem').returns(@menuItemView)

    afterEach ->
      Haml.render.restore()
      @view.template.restore()
      @menuItemStub.restore()

    it 'returns the view object', ->
      expect(@view.render()).toEqual(@view)

    it 'calls template method', ->
      @view.render()
      expect(@view.template).toHaveBeenCalledOnce()
      expect(@view.template).toHaveBeenCalledWithExactly()

    it 'calls Haml render method', ->
      @view.render()
      expect(Haml.render).toHaveBeenCalledOnce()

    it 'generates an UL list with ".taxonomies_list"', ->
      @view.render()
      expect($(@view.el)).toContain("ul.taxonomies_list")

    describe 'when taxonomy root has no children', ->        
      it 'does not create any menu item subview', ->
        @view.render()
        expect(@menuItemStub).not.toHaveBeenCalledOnce()

    describe 'when taxonomy root has children', ->
      beforeEach ->
        @taxon1.isLeaf.returns(false)
        @taxon1.children = sinon.stub().returns([@taxon2, @taxon3])

      it 'creates a menu item subview for each children', ->
        @view.render()
        expect(@menuItemStub).toHaveBeenCalledTwice()

      it 'renders each menu item subview', ->
        @view.render()
        expect(@menuItemView.render).toHaveBeenCalledTwice()

      it 'appends each menu item subview to the menu list', ->
        @view.render()
        expect($("ul.taxonomies_list").children().length).toEqual(3)

  describe 'events', ->
    it 'does not handle any UI event', ->
      expect(@view.events).toBeUndefined()