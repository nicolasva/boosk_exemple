describe "Model Customization", ->
  beforeEach ->
    App.current_shop = 1

  it "should be defined", ->
    expect(App.Customization).toBeDefined()

  it "can be instantiated", ->
    customization = new App.Customization
    expect(customization).not.toBeNull()
