describe "Model Shop Facebook", ->
  beforeEach ->
    @user_id = 1
    App.current_shop = 1
    @url = "/"+App.ui()+"/shops/#{App.current_shop}"

  it "should be defined", ->
    expect(App.Shop).toBeDefined()

  it "can be instantiated", ->
    shop = new App.Shop(uuid: App.current_shop) 
    expect(shop).not.toBeNull()

  describe "check url", ->
    beforeEach -> 
      @shop = new App.Shop(uuid: App.current_shop) 

    it "should return the shop url", ->
      expect(@shop.url()).toEqual(@url) 

  describe "shop fetch", ->
    beforeEach ->
      @shop_fixture =
        "name":"test_name_shop"
        "baseline": "name_baseline"
        "description": "description shop"
        "user_id": @user_id 
      @server = sinon.fakeServer.create()
      @shop = new App.Shop(@shop_fixture)
      @server.respondWith(
        "POST"
        @url,
        [
          200,
          {"Content-type" : "application/json"},
          @shop_fixture.toString()
        ]
      )
      @eventSpy = sinon.spy()
      @shop.save()

    afterEach ->
      @server.restore()

    it "should request requestBody to equal with shop_attributes ?", ->      
      expect(JSON.parse(@server.requests[0].requestBody)).toEqual(@shop.attributes)
