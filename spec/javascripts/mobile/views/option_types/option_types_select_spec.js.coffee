describe "option_types_select View Option_types mobile", ->
  beforeEach ->
    App.Views.OptionTypes.OptionTypesSelect.prototype.template = JST["app/assets/javascripts/mobile/templates/option_types/option_types_select"]
    @model_error = "Model Error"

    @viewsOptionTypesOptionTypesSelect = new App.Views.OptionTypes.OptionTypesSelect({model_error: @model_error})

  describe "instantiation", ->
    beforeEach ->
      @renderStub = sinon.stub(@viewsOptionTypesOptionTypesSelect, 'render')
      
    afterEach ->
      @renderStub.restore()

    it "binds on '.form_select_option' element", ->
      expect(@viewsOptionTypesOptionTypesSelect.$el.selector).toEqual(".form_select_option")

    it "renders immediately", ->
      @viewsOptionTypesOptionTypesSelect.initialize
        model_error: @model_error
      expect(@renderStub).toHaveBeenCalledOnce()

