describe 'App.Views.TaxRates.Edit', ->
  beforeEach ->
    App.Views.TaxRates.Edit.prototype.template = JST['app/assets/javascripts/backend/templates/tax_rates/edit']

    @translate = new Backbone.Model()
    @tax_rate = new Backbone.Model()

    @taxRateForm = new Backbone.View()
    @taxRateFormStub = sinon.stub(App.Views.TaxRates, 'Form').returns(@taxRateForm)

    @view = new App.Views.TaxRates.Edit(model: @tax_rate, translate: @translate)
    
    setFixtures(sandbox(id: "modal"))
    $(@view.el).appendTo("#jasmine-fixtures")

  afterEach ->
    @taxRateFormStub.restore()

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
      @taxRateFormStub.reset()

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

    it 'creates a tax rate form', ->
      @view.render()
      expect(@taxRateFormStub).toHaveBeenCalledOnce()

  describe 'events', ->
    describe 'when tax rate form is submitted', ->
      beforeEach ->
        sinon.spy(App.eventsDispatcher, 'trigger')
        @saveTaxRateStub = sinon.stub(@tax_rate, 'save')

      afterEach ->
        App.eventsDispatcher.trigger.restore()
        @saveTaxRateStub.restore()

      it 'triggers "startLoading" event', ->
        $("#edit_tax_rate_form").submit()
        expect(App.eventsDispatcher.trigger).toHaveBeenCalledOnce()
        expect(App.eventsDispatcher.trigger).toHaveBeenCalledWith('startLoading')

      it 'saves tax rate model', ->
        $("#edit_tax_rate_form").submit()
        expect(@saveTaxRateStub).toHaveBeenCalledOnce()

      describe 'when model save is successful', ->
        beforeEach ->
          @saveTaxRateStub.yieldsTo('success', @tax_rate)
          @historyNavigateStub = sinon.stub(Backbone.history, 'navigate')

        afterEach ->
          @historyNavigateStub.restore()

        it 'triggers "loadingComplete" event', ->
          $("#edit_tax_rate_form").submit()
          expect(App.eventsDispatcher.trigger).toHaveBeenCalledTwice()
          expect(App.eventsDispatcher.trigger).toHaveBeenCalledWith('loadingComplete')

        describe 'and view has been set as modal', ->
          beforeEach ->
            @view.modal = $("#modal")
            sinon.spy(jQuery.prototype, 'modal')

          afterEach ->
            jQuery.prototype.modal.restore()

          it 'does not redirect', ->
            $("#edit_tax_rate_form").submit()
            expect(@historyNavigateStub).not.toHaveBeenCalled()

          it 'close the modal', ->
            $("#edit_tax_rate_form").submit()
            expect(jQuery.prototype.modal).toHaveBeenCalledOnce()
            expect(jQuery.prototype.modal).toHaveBeenCalledWithExactly('hide')

        describe 'and view has not been set as modal', ->
          it 'redirects to tax rates index view', ->
            $("#edit_tax_rate_form").submit()
            expect(@historyNavigateStub).toHaveBeenCalledOnce()
            expect(@historyNavigateStub).toHaveBeenCalledWithExactly '#/settings/tax_rates', true

      describe 'when model save fails', ->
        beforeEach ->
          @noticeViewStub = sinon.stub(App.Views, 'Notice').returns(new Backbone.View())
          @saveTaxRateStub.yieldsTo('error', @tax_rate, {status: 422, responseText: ""})

        afterEach ->
          @noticeViewStub.restore()

        it 'triggers "loadingComplete" event', ->
          $("#edit_tax_rate_form").submit()
          expect(App.eventsDispatcher.trigger).toHaveBeenCalledTwice()
          expect(App.eventsDispatcher.trigger).toHaveBeenCalledWith('loadingComplete')

        it 'creates a notice view', ->
          $("#edit_tax_rate_form").submit()
          expect(@noticeViewStub).toHaveBeenCalledOnce()
