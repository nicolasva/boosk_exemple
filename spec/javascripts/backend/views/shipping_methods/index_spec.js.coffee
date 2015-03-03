describe "App.Views.ShippingMethods.Index", ->
  beforeEach ->
    App.Views.ShippingMethods.Index.prototype.template = JST['app/assets/javascripts/backend/templates/shipping/methods/index']
    App.Views.ShippingMethods.Index.prototype.store_settings_menu = JST['app/assets/javascripts/backend/templates/shared/store_settings_menu']
    App.Views.ShippingMethods.Index.prototype.support_block = JST['app/assets/javascripts/backend/templates/shared/support_block']

    @translate = new Backbone.Model
      add: ""
      back: ""
      delete: ""
      next: ""
      actions: ""
      activerecord:
        attributes:
          shipping_method:
            name: ""
        models:
          zone: ""
      views:
        shipping_method:
          index:
            h2: ""
          you_have_not_yet_shippings_methods: ""
          add_shipping_method: ""
    @shop = new Backbone.Model()
    @method1 = new Backbone.Model(id: 1, name: "Method 1", zone: {name: "Zone 1"})
    @method2 = new Backbone.Model(id: 2, name: "Method 2", zone: {name: "Zone 2"})
    @methods = new Backbone.Collection([@method1, @method2])

    @view = new App.Views.ShippingMethods.Index
      collection: @methods
      translate: @translate
      shop: @shop
      wizard: false

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'should create a SECTION element', ->
      expect(@view.el.tagName).toEqual("SECTION")

    it "does not render immediately", ->
      @view.initialize(translate: @translate)
      expect(@renderStub).not.toHaveBeenCalled()

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
    beforeEach ->
      $(@view.render().el).appendTo("body")

    afterEach ->
      $(@view.el).remove()

    it 'handle correct UI events', ->
      expect(@view.events).toEqual
        "change .action": "perform_action"
        "click .edit" : "edit"
        "click .select-all": "select_all"
        "click #new_method" : "new"

    describe "when 'destroy' action is selected", ->
      beforeEach ->
        @popupStub = sinon.stub(App.Views, 'Popup').returns(new Backbone.View())
        @methodsBulkDestroyStub = sinon.stub(@methods, 'bulk_destroy').yieldsTo('success', [@method1], [@method1])

      afterEach ->
        @popupStub.restore()
        @methodsBulkDestroyStub.restore()

      describe "and no method was selected", ->
        beforeEach ->
          $(".action").val("0")
          $(".action").change()

        it "shows a warning pop up", ->
          expect(@popupStub).toHaveBeenCalledOnce()

        it "does not destroy any method", ->
          expect(@methodsBulkDestroyStub).not.toHaveBeenCalled()

      describe "and there is a selected method", ->
        beforeEach ->
          $('.method-selected').first().prop('checked', true)
          $(".action").val("0")
          $(".action").change()

        it "does not show a warning pop up", ->
          expect(@popupStub).not.toHaveBeenCalled()

        it "destroys selected method", ->
          expect(@methodsBulkDestroyStub).toHaveBeenCalledOnce()

    describe "when 'edit' button is clicked", ->
      beforeEach ->
        @editMethodViewStub = sinon.stub(App.Views.ShippingMethods, 'Edit').returns(new Backbone.View())
        $(".edit").first().click()

      afterEach ->
        @editMethodViewStub.restore()

      it "creates a method edit view", ->
        expect(@editMethodViewStub).toHaveBeenCalledOnce()

    describe "when 'select all' button is checked", ->
      beforeEach ->
        $(".select-all").prop("checked", true)
        $(".select-all").click()

      it "selects all methods", ->
        expect($(".method-selected:checked").length).toEqual(@methods.length)

    describe "when 'select all' is unchecked", ->
      beforeEach ->
        $('.method-selected').first().prop("checked", true)
        $(".select-all").prop("checked", false)
        $(".select-all").click()        

      it "unselects all methods", ->
        expect($(".method-selected:checked").length).toEqual(0)

    describe "when 'new method' button is clicked", ->
      beforeEach ->
        @newMethodViewStub = sinon.stub(App.Views.ShippingMethods, 'New').returns(new Backbone.View())
        $("#new_method").click()

      afterEach ->
        @newMethodViewStub.restore()

      it 'creates a method creation view', ->
        expect(@newMethodViewStub).toHaveBeenCalledOnce()