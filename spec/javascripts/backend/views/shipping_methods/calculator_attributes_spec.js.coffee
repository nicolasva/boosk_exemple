describe 'App.Views.ShippingMethods.CalculatorAttributes', ->
  beforeEach ->
    App.Views.ShippingMethods.CalculatorAttributes.prototype.template = JST['app/assets/javascripts/backend/templates/shipping/methods/calculator_attributes']
    @calculator1 = new Backbone.Model(name: "type1")
    @calculator2 = new Backbone.Model(name: "type2")
    @calculators = new Backbone.Collection([@calculator1, @calculator2])
    @translate = new Backbone.Model()
    @method = new Backbone.Model(calculator_type: "type1")

    @view = new App.Views.ShippingMethods.CalculatorAttributes
      calculator_types: @calculators
      model: @method
      translate : @translate.toJSON()

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'should create a DIV element', ->
      expect(@view.el.tagName).toEqual("DIV")

    it "renders immediately", ->
      @view.initialize(translate: @translate)
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
      expect(Haml.render).toHaveBeenCalledOnce()

  describe 'events', ->
    it 'should not handle any UI event', ->
      expect(@view.events).toBeUndefined()