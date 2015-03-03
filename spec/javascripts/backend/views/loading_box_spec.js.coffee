describe 'App.Views.LoadingBox', ->
  beforeEach ->
    App.Views.LoadingBox.prototype.template = JST['app/assets/javascripts/backend/templates/loading_box']
    @view = new App.Views.LoadingBox()

  describe 'instanciation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it "creates a DIV element with a 'loading-box-wrapper' ID", ->
      expect($(@view.el)).toBe("div#loading-box-wrapper")

    it "does not render immediately", ->
      @view.initialize()
      expect(@renderStub).not.toHaveBeenCalled()

  describe 'rendering', ->
    beforeEach ->
      sinon.spy(Haml, 'render')
      $(@view.el).appendTo("body")

    afterEach ->
      Haml.render.restore()
      $(@view.el).remove()

    it 'returns the view object', ->
      expect(@view.render()).toEqual(@view)

    it "contains a 'loading-box' div", ->
      @view.render()
      expect($(@view.el)).toContain("div#loading-box")

    it "contains 'Chargement...' text", ->
      @view.render()
      expect(@view.$("#loading-box")).toHaveText(/Chargement.../)

    it 'is initially hidden', ->
      @view.render()
      expect($(@view.el)).toBeHidden()

  describe 'hide method', ->
    beforeEach ->
      $(@view.render().el).appendTo("body")

    afterEach ->
      $(@view.el).remove()

    it 'returns the view object', ->
      expect(@view.show()).toEqual(@view)

    it 'hides view', ->
      $(@view.el).show()
      @view.hide()
      expect($(@view.el)).toBeHidden()

  describe 'show method', ->
    beforeEach ->
      $(@view.render().el).appendTo("body")

    afterEach ->
      $(@view.el).remove()

    it 'returns the view object', ->
      expect(@view.hide()).toEqual(@view)

    it 'shows view', ->
      $(@view.el).hide()
      @view.show()
      expect($(@view.el)).toBeVisible()

  describe 'global events handling', ->
    beforeEach ->
      $(@view.render().el).appendTo("body")

    afterEach ->
      $(@view.el).remove()

    describe 'on "startLoading" event', ->
      it 'shows view', ->
        $(@view.el).hide()
        App.eventsDispatcher.trigger('startLoading')
        expect($(@view.el)).toBeVisible()

    describe 'on "loadingComplete" event', ->
      it 'hides view', ->
        $(@view.el).show()
        App.eventsDispatcher.trigger('loadingComplete')
        expect($(@view.el)).toBeHidden()        