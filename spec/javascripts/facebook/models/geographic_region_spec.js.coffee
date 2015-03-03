describe "Model Geographic", ->
  beforeEach ->
    @order = new App.Order()

  it "should be defined", ->
    expect(@order).toBeDefined()

  it "can be instantiated", ->
    expect(@order).not.toBeNull()
