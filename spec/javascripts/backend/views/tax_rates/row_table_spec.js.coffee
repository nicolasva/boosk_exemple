describe 'App.Views.TaxRates.RowTable', ->
  beforeEach ->
    App.Views.TaxRates.RowTable.prototype.template = JST['app/assets/javascripts/backend/templates/tax_rates/row_table']

    @translate = new Backbone.Model
      views:
        tax_rate:
          edit_tax: ""
    @zones = new Backbone.Collection()
    @tax_rate = new Backbone.Model(id: 42)

    @view = new App.Views.TaxRates.RowTable(model: @tax_rate, zones: @zones, translate: @translate.toJSON())

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'creates a TR element', ->
      expect($(@view.el)).toBe("tr")

    it 'does not render immediately', ->
      @view.initialize(model: @tax_rate, zones: @zones, translate: @translate.toJSON())
      expect(@renderStub).not.toHaveBeenCalled()

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

    it 'adds model id as data-* attribute on view root element', ->
      @view.render()
      expect(@view.$el).toHaveAttr('data-id', @tax_rate.id)

  describe 'when "edit" link is clicked', ->
    beforeEach ->
      @view.render()
      @editViewStub = sinon.stub(App.Views.TaxRates, 'Edit').returns(new Backbone.View())
      sinon.spy(jQuery.prototype, 'modal')

    afterEach ->
      @editViewStub.restore()
      jQuery.prototype.modal.restore()

    it 'creates an edit view', ->
      @view.$('.edit').click()
      expect(@editViewStub).toHaveBeenCalledOnce()

    it 'modalizes the view created', ->
      @view.$('.edit').click()
      expect(jQuery.prototype.modal).toHaveBeenCalledOnce()

  describe 'when model changes', ->
    beforeEach ->
      sinon.spy(@tax_rate, 'on')

    afterEach ->
      @tax_rate.on.restore()

    it 'renders the view', ->
      @view = new App.Views.TaxRates.RowTable(model: @tax_rate, zones: @zones, translate: @translate.toJSON())
      expect(@tax_rate.on).toHaveBeenCalled()
      expect(@tax_rate.on).toHaveBeenCalledWithExactly('change', @view.render, @view)      

  describe 'when model is destroyed', ->
    beforeEach ->
      @view.render()
      @removeStub = sinon.stub(@view, 'remove')
      @clock = sinon.useFakeTimers()

    afterEach ->
      @removeStub.restore()
      @clock.restore()

    it 'removes the view', ->
      @tax_rate.trigger('destroy', @tax_rate, @tax_rate.collection, {})
      @clock.tick(510)
      expect(@removeStub).toHaveBeenCalledOnce()