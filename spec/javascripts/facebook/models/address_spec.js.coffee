describe "Model Address Facebook", ->
  beforeEach ->
    @address = new App.Address()

  it "should be defined", ->
    expect(@address).toBeDefined()

  it "can be instantiated", ->
    expect(@address).not.toBeNull()

