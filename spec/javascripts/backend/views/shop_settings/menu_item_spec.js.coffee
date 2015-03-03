describe 'App.Views.ShopSettings.MenuItem', ->
  beforeEach ->
    App.Views.ShopSettings.MenuItem.prototype.template = JST['app/assets/javascripts/backend/templates/shop_settings/menu_item']

    @taxon1 = new Backbone.Model(id: 1, name: "Taxon 1")
    @taxon2 = new Backbone.Model(id: 2, name: "Taxon 2")
    @taxon3 = new Backbone.Model(id: 3, name: "Taxon 3")

    @view = new App.Views.ShopSettings.MenuItem(model: @taxon1)
    $(@view.el).appendTo("body")

  afterEach ->
    $(@view.el).remove()

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'creates a LI element', ->
      expect($(@view.el)).toBe('li')

    it 'does not render immediately', ->
      @view.initialize(model: @taxon1)
      expect(@renderStub).not.toHaveBeenCalled()

  describe 'rendering', ->
    beforeEach ->
      sinon.spy(Haml, 'render')
      sinon.spy(@view, 'template')
      @taxon1.isLeaf = sinon.stub().returns(true)
      @subMenuItemView = new Backbone.View()
      @subMenuItemView.render = () ->
        @el = document.createElement('li')
        return @
      sinon.spy(@subMenuItemView, 'render')
      @menuItemStub = sinon.stub(App.Views.ShopSettings, 'MenuItem').returns(@subMenuItemView)

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

    it 'stores model ID in data-* attribute', ->
      @view.render()
      expect($(@view.el)).toHaveAttr('data-id', @taxon1.id)

    it 'produces the correct HTML', ->
      @view.render()
      expect($(@view.el)).toHaveHtml("<a href='#'>Taxon 1</a>")

    describe 'when taxon has no children', ->

      it 'does not produce an UL list', ->
        @view.render()
        expect($(@view.el)).not.toContain("ul")

      it 'does not create any menu item subview', ->
        @view.render()
        expect(@menuItemStub).not.toHaveBeenCalled()

    describe 'when taxon has children', ->
      beforeEach ->
        @taxon1.isLeaf.returns(false)
        @taxon1.children = sinon.stub().returns([@taxon2, @taxon3])
        @taxon2.isLeaf = sinon.stub().returns(true)
        @taxon3.isLeaf = sinon.stub().returns(true)

      it 'produces an UL list with "children-menu" class', ->
        @view.render()
        expect($(@view.el)).toContain("ul.children-menu")

      it 'creates a menu item subview for each children', ->
        @view.render()
        expect(@menuItemStub).toHaveBeenCalledTwice()

      it 'renders each subview', ->
        @view.render()
        expect(@subMenuItemView.render).toHaveBeenCalledTwice()

      it 'appends each subview to the list', ->
        @view.render()
        expect($("ul.children-menu").children().length).toEqual(2)

  describe 'events', ->
    it 'does not handle any event', ->
      expect(@view.events).toBeUndefined()
