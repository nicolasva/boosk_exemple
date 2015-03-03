describe "Wizard Router", ->
  beforeEach ->
    @router = new App.Routers.Wizards()

    @routes =
      "/w_step1":  "w_step1"
      "/w_step2":  "w_step2"
      "/w_step3":  "w_step3"

    #stub collections
    @collection = new Backbone.Collection()
    @devisesCollectionStub = sinon.stub(window['App.Collections.Devises']).returns(@collection)

    #stub views
    @wizardStep1ViewStub = sinon.stub(window['App.Views.Wizards.Step1'])
    @wizardStep2ViewStub = sinon.stub(window['App.Views.Wizards.Step2'])
    @wizardStep3ViewStub = sinon.stub(window['App.Views.Wizards.Step3'])

  describe "testing routes exist ?", ->
    it "routes testing routing w_step1 ?", ->
      expect(@router["routes"]["/w_step1"]).toEqual(@routes["/w_step1"])

    it "routes testing routing w_step2", ->
      expect(@router["routes"]["/w_step2"]).toEqual(@routes["/w_step2"])

    it "routes testing routing w_step3", ->
      expect(@router["routes"]["/w_step3"]).toEqual(@routes["/w_step3"])

  describe "Collections Wizards", ->
    describe "when list exists on w_step1", ->
      beforeEach ->
        @router.w_step1

      it "creates a Wizard list collection", ->
        expect(@devisesCollectionStub).toHaveBeenCalledOnce

  describe "View Wizards", ->
    describe "when list exists on w_step1", ->
      beforeEach ->
        @router.w_step1

      it "creates a Wizard view", ->
        expect(@wizardStep1ViewStub).toHaveBeenCalledOnce
        expect(@wizardStep1ViewStub).toHaveBeenCalledWith

    describe "when list exists on w_step2", ->
      beforeEach ->
        @router.w_step2

      it "creates a Wizard view", ->
        expect(@wizardStep2ViewStub).toHaveBeenCalledOnce
        expect(@wizardStep2ViewStub).toHaveBeenCalledWith

    describe "when list exists on w_step3", ->
      beforeEach ->
        @router.w_step3

      it "creates a Wizard view", ->
        expect(@wizardStep3ViewStub).toHaveBeenCalledOnce
        expect(@wizardStep3ViewStub).toHaveBeenCalledWith

  describe "testing routing", ->
    beforeEach ->
      @routeSpy = sinon.spy
      try
        Backbone.history.start({silent:true, pushState:true})
      catch e
      @router.navigate("elsewhere")

    it "testing w_step1", ->
      @router.bind("route:w_step1", @routeSpy)
      @router.navigate("/w_step1", true)
      expect(@routeSpy).toHaveBeenCalledOnce
      expect(@routeSpy).toHaveBeenCalledWith

    it "testing w_step2", ->
      @router.bind("route:w_step2", @routeSpy)
      @router.navigate("/w_step2", true)
      expect(@routeSpy).toHaveBeenCalledOnce
      expect(@routeSpy).toHaveBeenCalledWith

    it "testing w_step3", ->
      @router.bind("route:w_step3", @routeSpy)
      @router.navigate("/w_step3", true)
      expect(@routeSpy).toHaveBeenCalledOnce
      expect(@routeSpy).toHaveBeenCalledWith
