describe "Model Taxon Facebook", ->
  beforeEach ->
    @taxon = new App.Taxon()

  it "should be defined", ->
    expect(@taxon).toBeDefined()

  it "can be instantiated", ->
    expect(@taxon).not.toBeNull()
