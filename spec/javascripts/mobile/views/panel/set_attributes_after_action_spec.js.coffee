describe "set_attributes_after_action Views Panel Mobile", ->
  beforeEach ->
    @viewsPanelSetAttributesAfterAction = new App.Views.Panel.SetAttributesAfterAction()

  describe "instantiation", ->
    beforeEach ->
      @renderStub = sinon.stub(@viewsPanelSetAttributesAfterAction, 'render')

    afterEach ->
      @renderStub.restore()

    it "renders immediately", ->
      @viewsPanelSetAttributesAfterAction.initialize()
      expect(@renderStub).toHaveBeenCalledOnce()
