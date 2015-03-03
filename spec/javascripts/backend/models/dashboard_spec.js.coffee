describe "Model Dashboard", ->
  beforeEach ->
    @url = "/dashboard"

  it "should be defined", ->
    expect(App.Dashboard).toBeDefined()

  it "can be instantiated", ->
    dashboard = new App.Dashboard 
    expect(dashboard).not.toBeNull()

  describe "check url", ->
    beforeEach ->
      @dashboard = new App.Dashboard

    it "should return to dashboard url", ->
      expect(@dashboard.url()).toEqual(@url)

