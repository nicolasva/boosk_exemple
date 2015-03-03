describe "Contact Model", ->
  beforeEach ->
    @contact = new App.Contact()

  it "should be defined", ->
    expect(@contact).toBeDefined()

  it "can be instantiated", ->
    expect(@contact).not.toBeNull()

