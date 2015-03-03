describe "App.Views.ShippingMethods.Form", ->
  beforeEach ->
    App.Views.ShippingMethods.Form.prototype.template = JST['app/assets/javascripts/backend/templates/shipping/methods/form']

    @zones = new Backbone.Collection()
    @translate = new Backbone.Model
      activerecord:
        attributes:
          shipping_method:
            name: ""
        models:
          zone: ""
          calculator: ""
          test: "Test"
          test2: "Test 2"
      views:
        shipping_method:
          name_example: ""
          help_block_name: ""
          help_block_zone: ""
          help_block_type: ""
        zone:
          add_zone: ""
          help_block_add_zone: ""
      create: ""
      update: ""
      close: ""
    @method = new Backbone.Model
      calculator_type: "test"
    @method.zone = new Backbone.Model()

    @calculator1 = new Backbone.Model(id: 1, name: "test", i18n_key: "test")
    @calculator2 = new Backbone.Model(id: 2, name: "test2", i18n_key: "test2")
    @calculators = new Backbone.Collection([@calculator1, @calculator2])

    @calculatorsCollectionStub = sinon.stub(App.Collections, 'CalculatorTypes').returns(@calculators)
    @fetchZonesStub = sinon.stub(@zones, 'fetch').yieldsTo('success', @zones)
    @fetchCalculatorsStub = sinon.stub(@calculators, 'fetch').yieldsTo('success', @calculators)

    @calculatorAttributesViewStub = sinon.stub(App.Views.ShippingMethods, 'CalculatorAttributes').returns(new Backbone.View())

    @view = new App.Views.ShippingMethods.Form
      zones: @zones
      translate: @translate.toJSON()
      model: @method
    $(@view.el).appendTo("body")


  afterEach ->
    @calculatorsCollectionStub.restore()
    @fetchZonesStub.restore()
    @fetchCalculatorsStub.restore()
    @calculatorAttributesViewStub.restore()

    $(@view.el).remove()

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'should create a DIV element', ->
      expect(@view.el.tagName).toEqual("DIV")

    it "renders immediately", ->
      @view.initialize(zones: @zones, translate: @translate.toJSON(), model: @method)
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
      expect(@view.template).toHaveBeenCalledWithExactly(model: @method)

    it 'calls Haml render method', ->
      expect(Haml.render).toHaveBeenCalledOnce()

    it 'fetches zones', ->
      expect(@fetchZonesStub).toHaveBeenCalledTwice()

    it 'fetches calculator types', ->
      expect(@fetchCalculatorsStub).toHaveBeenCalledTwice()

    it 'adds two options to the calculator type selector', ->
      expect($("#shipping_method_calculator_type option").length).toEqual 2

    it 'creates a calculator attributes subview', ->
      expect(@calculatorAttributesViewStub).toHaveBeenCalledTwice()

  describe 'events', ->

    it 'should handle correct UI events', ->
      expect(@view.events).toEqual
        "change #shipping_method_calculator_type": "changeCalcType"

    describe "when a new calculator type is selected", ->
      beforeEach ->
        sinon.spy(@method, 'set')
        $("#shipping_method_calculator_type").val("test2")
        $("#shipping_method_calculator_type").change()

      afterEach ->
        @method.set.restore()

      it "should update current method with new type", ->
        expect(@method.set).toHaveBeenCalledOnce()
        expect(@method.get('calculator_type')).toEqual "test2"

    describe "when new zone is added to collection", ->
      beforeEach ->
        $("#shipping_method_zone_id").empty()
        @zones.add(new Backbone.Model(id: 3, name: "Zone 3"))

      afterEach ->
        $("#shipping_method_zone_id").empty()

      it "should add a new option to zone selector", ->
        expect($("#shipping_method_zone_id option").length).toEqual 1