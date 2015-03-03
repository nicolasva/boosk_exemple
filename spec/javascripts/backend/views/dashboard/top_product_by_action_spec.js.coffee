describe 'App.Views.Dashboard.TopProductsByAction', ->
  beforeEach ->
    App.Views.Dashboard.TopProductsByAction.prototype.template = JST['app/assets/javascripts/backend/templates/dashboard/top_products_by_action']
    $("<div id='top-products-by-action'><div class='content'></div></div>").appendTo("body")

    @top_products = new Backbone.Collection()
    @translate = new Backbone.Model()
    @products = new Backbone.Collection()

    @view = new App.Views.Dashboard.TopProductsByAction
      top_products: @top_products
      translate: @translate
      products: @products
      action: "test"
      forbidden: false

  afterEach ->
    $("#top-products-by-action").remove()

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'binds on "app" element', ->
      expect(@view.$el.selector).toEqual("#top-products-by-action .content")

    it 'renders immediately', ->
      @view.initialize
        top_products: @top_products
        translate: @translate
        products: @products
        action: "test"
        forbidden: false
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
    it 'handles correct events', ->
      expect(@view.events).toBeUndefined()
