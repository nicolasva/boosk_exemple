describe 'App.Views.Customizations.PictureView', ->
  beforeEach ->
    App.Views.Customizations.PictureView.prototype.template = JST['app/assets/javascripts/backend/templates/customizations/_picture_view']

    @view = new App.Views.Customizations.PictureView
      picture:
        url: "blabla"
        cached_name: "test"
      picture_type: "test"

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'creates a div element', ->
      expect(@view.el.nodeName).toEqual('DIV')

    it 'renders immediately', ->
      @view.initialize
        picture:
          url: "blabla"
          cached_name: "test"
        picture_type: "test"
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