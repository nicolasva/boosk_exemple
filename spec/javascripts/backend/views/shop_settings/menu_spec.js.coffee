describe 'App.Views.ShopSettings.Menu', ->
  beforeEach ->
    App.Views.ShopSettings.Menu.prototype.template = JST['app/assets/javascripts/backend/templates/shop_settings/menu']
    App.Views.ShopSettings.Menu.prototype.store_settings_menu = JST['app/assets/javascripts/backend/templates/shared/store_settings_menu']
    App.Views.ShopSettings.Menu.prototype.support_block = JST['app/assets/javascripts/backend/templates/shared/store_settings_menu']

    @translate = new Backbone.Model
      views:
        menu:
          edit:
            h2: ""
            h2_bis: ""
            menu_bar: ""
          home: ""
      add: ""
      rename: ""
      delete: ""
      back: ""
      next: ""
      update: ""

    @shop = new Backbone.Model()
    @taxonomy = new Backbone.Model()
    @taxon1 = new Backbone.Model(id: 1)
    @taxon2 = new Backbone.Model(id: 2)
    @taxon3 = new Backbone.Model(id: 3)
    @taxon1.isLeaf = sinon.stub().returns(true)
    @taxons = new Backbone.Collection()
    @taxons.root = sinon.stub().returns(@taxon1)
    @taxonomy.taxons = @taxons
    @fetchTaxonsStub = sinon.stub(@taxons, 'fetch').yieldsTo('success', @taxons)
    @menuPreview = new Backbone.View()
    @menuPreviewStub = sinon.stub(App.Views.ShopSettings, 'MenuPreview').returns(@menuPreview)

    $("<div id='app'></div>").appendTo("body")
    @view = new App.Views.ShopSettings.Menu(model: @taxonomy, shop: @shop, translate: @translate, wizard: false)

  afterEach ->
    $("#app").remove()
    @fetchTaxonsStub.restore()
    @menuPreviewStub.restore()

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'should create a SECTION element', ->
      expect($(@view.el)).toBe('section#store-settings.container-fluid')

    it 'renders immediately', ->
      @view.initialize(model: @taxonomy, shop: @shop, translate: @translate, wizard: false)
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

    it 'checks if taxons root have child', ->
      expect(@taxon1.isLeaf).toHaveBeenCalledOnce()

    describe 'when root has children', ->
      beforeEach ->
        @taxon1.isLeaf.returns(false)
        @taxon1.children = sinon.stub().returns([@taxon2, @taxon3])
        @menuItemView = new Backbone.View()
        @menuItemView.render = () ->
          @el = document.createElement('li')
          return @
        @menuItemRenderSpy = sinon.spy(@menuItemView, 'render')
        @menuItemStub = sinon.stub(App.Views.ShopSettings, 'MenuItem').returns(@menuItemView)
        sinon.spy(jQuery.prototype, "jstree")

        @view.render()

      afterEach ->
        @menuItemStub.restore()
        jQuery.prototype.jstree.restore()

      it 'asks for root children', ->
        expect(@taxon1.children).toHaveBeenCalledOnce()

      it 'creates a menu item subview for each children', ->
        expect(@menuItemStub).toHaveBeenCalledTwice()

      it 'renders each menu item subview', ->
        expect(@menuItemView.render).toHaveBeenCalledTwice()

      it 'append subviews created to menu list', ->
        expect($('#menu-root .children-menu').children().length).toEqual(3)

      it 'wraps menu with jstree', ->
        expect(jQuery.prototype.jstree).toHaveBeenCalledOnce()

      it 'creates a menu preview', ->
        expect(@menuPreviewStub).toHaveBeenCalledTwice() #two calls to view's render

      it 'appends menu preview to global menu view', ->
        expect($("#menu-preview-container")).toContain($(@menuPreview.el))

  describe "events", ->
    beforeEach ->
      @jsTreeStub = sinon.stub(jQuery.prototype, "jstree")

    afterEach ->
      @jsTreeStub.restore()

    it 'handles correct UI events', ->
      expect(@view.events).toEqual
        "click #add-item" : "addItem"
        "click #rename-item" : "renameItem"
        "click #destroy-item" : "destroyItem"
        "click #submit": "save"

    describe "when 'add' button is clicked", ->
      it 'creates a new node in the tree', ->
        $("#add-item").prop("disabled", false).click()
        expect(@jsTreeStub).toHaveBeenCalledOnce()
        expect(@jsTreeStub).toHaveBeenCalledWith('create')

    describe "when 'rename' button is clicked", ->
      it 'sets current node in rename mode', ->
        $("#rename-item").prop("disabled", false).click()
        expect(@jsTreeStub).toHaveBeenCalledOnce()
        expect(@jsTreeStub).toHaveBeenCalledWith('rename')

    describe "when 'delete' button is clicked", ->
      it 'removes a node', ->
        $("#destroy-item").prop("disabled", false).click()
        expect(@jsTreeStub).toHaveBeenCalledOnce()
        expect(@jsTreeStub).toHaveBeenCalledWith('remove')

  describe 'jsTree events', ->
    describe 'when a node is created', ->
      beforeEach ->
        @nodeStub = $("<div id='test'></div>").appendTo("body")
        @parentStub = $("<div id='parent' data-id='2'></div>").appendTo("body")
        @data = 
          rslt:
            position: 1
            name: "Test"
            obj: @nodeStub
            parent: @parentStub
        @createTaxonsStub = sinon.stub(@taxons, 'create').yieldsTo('success', @taxon3)

      afterEach ->
        @createTaxonsStub.restore()
        $("#test").remove()
        $("#parent").remove()

      it 'creates corresponding taxon in taxonomy collection', ->
        $('#menu-container').trigger('create.jstree', @data)
        expect(@createTaxonsStub).toHaveBeenCalledOnce()

      it 'updates DOM node with taxon ID', ->
        $('#menu-container').trigger('create.jstree', @data)
        expect(@nodeStub).toHaveAttr("data-id", @taxon3.id)

    describe 'when a node is renamed', ->
      beforeEach ->
        @nodeStub = $("<div id='test' data-id='2'></div>").appendTo("body")
        @data = 
          rslt:
            obj: @nodeStub
            new_name: "Test"
        @getTaxonsStub = sinon.stub(@taxons, 'get')
        @getTaxonsStub.withArgs('2').returns(@taxon2)
        @saveTaxonStub = sinon.stub(@taxon2, 'save')

      afterEach ->
        @getTaxonsStub.restore()
        @saveTaxonStub.restore()
        $("#test").remove()

      it 'gets corresponding taxon model', ->
        $('#menu-container').trigger('rename.jstree', @data)
        expect(@getTaxonsStub).toHaveBeenCalledOnce()
        expect(@getTaxonsStub).toHaveBeenCalledWithExactly("2")

      it 'updates corresponding model with new name', ->
        $('#menu-container').trigger('rename.jstree', @data)
        expect(@saveTaxonStub).toHaveBeenCalledOnce()

    describe 'when a node is deleted', ->
      beforeEach ->
        @nodeStub = $("<div id='test' data-id='2'></div>").appendTo("body")
        @data = 
          rslt:
            obj: @nodeStub
        @getTaxonsStub = sinon.stub(@taxons, 'get')
        @getTaxonsStub.withArgs('2').returns(@taxon2)
        @destroyTaxonStub = sinon.stub(@taxon2, 'destroy')

      afterEach ->
        @getTaxonsStub.restore()
        @destroyTaxonStub.restore()
        $("#test").remove()

      it 'gets corresponding taxon model', ->
        $('#menu-container').trigger('remove.jstree', @data)
        expect(@getTaxonsStub).toHaveBeenCalledOnce()
        expect(@getTaxonsStub).toHaveBeenCalledWithExactly("2")

      it 'destroys corresponding model', ->
        $('#menu-container').trigger('remove.jstree', @data)
        expect(@destroyTaxonStub).toHaveBeenCalledOnce()

    describe 'when a node is selected', ->
      beforeEach ->
        $("#add-item").prop("disabled", true)
        $("#rename-item").prop("disabled", false)
        $("#destroy-item").prop("disabled", false)

      describe 'and the node is the tree root', ->
        beforeEach ->
          @data = {rslt: {obj: $("#menu-root")}}

        it "enables 'add' button", ->
          $('#menu-container').trigger('select_node.jstree', @data)
          expect($("#add-item")).not.toBeDisabled()

        it "disables 'rename' button", ->
          $('#menu-container').trigger('select_node.jstree', @data)
          expect($("#rename-item")).toBeDisabled()

        it "disables 'delete' button", ->
          $('#menu-container').trigger('select_node.jstree', @data)
          expect($("#destroy-item")).toBeDisabled()

      describe 'and the node is not the tree root', ->
        beforeEach ->
          @nodeStub = $("<div id='test' data-id='2'></div>").appendTo("body")
          @data = {rslt: {obj: @nodeStub}}

        afterEach ->
          $("#test").remove()

        it "enables 'add' button", ->
          $('#menu-container').trigger('select_node.jstree', @data)
          expect($("#add-item")).not.toBeDisabled()

        it "enables 'rename' button", ->
          $('#menu-container').trigger('select_node.jstree', @data)
          expect($("#rename-item")).not.toBeDisabled()

        it "enables 'delete' button", ->
          $('#menu-container').trigger('select_node.jstree', @data)
          expect($("#destroy-item")).not.toBeDisabled()

    describe 'when a node is unselected', ->
      beforeEach ->
        $("#add-item").prop("disabled", false)
        $("#rename-item").prop("disabled", false)
        $("#destroy-item").prop("disabled", false)

      it "disables 'add' button", ->
        $('#menu-container').trigger('deselect_node.jstree')
        expect($("#add-item")).toBeDisabled()

      it "disables 'rename' button", ->
        $('#menu-container').trigger('deselect_node.jstree')
        expect($("#rename-item")).toBeDisabled()

      it "disables 'delete' button", ->
        $('#menu-container').trigger('deselect_node.jstree')
        expect($("#destroy-item")).toBeDisabled()
