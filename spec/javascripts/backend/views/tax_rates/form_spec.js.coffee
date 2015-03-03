describe 'App.Views.TaxRates.Form', ->
  beforeEach ->
    App.Views.TaxRates.Form.prototype.template = JST['app/assets/javascripts/backend/templates/tax_rates/form']

    @tax_rate = new Backbone.Model()
    @translate = new Backbone.Model()

    @view = new App.Views.TaxRates.Form(model: @tax_rate, translate: @translate.toJSON())

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'should create a DIV element', ->
      expect($(@view.el)).toBe("div")

    it 'renders immediately', ->
      @view.initialize(model: @tax_rate, translate: @translate)
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
      expect(Haml.render).toHaveBeenCalledOnce()
