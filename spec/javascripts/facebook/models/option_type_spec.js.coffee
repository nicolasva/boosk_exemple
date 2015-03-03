describe "Model OptionType", ->
  beforeEach ->
    App.current_shop = 1
    @option_type_id = 1
    @namespace_facebook = "/"+App.ui()
    @url_shops = "/shops/"
    @url_option_types = "/option_types"
    @option_type_url = "#{@namespace_facebook}#{@url_shops}#{App.current_shop}#{@url_option_types}"
    @option_type = new App.OptionType()
    @option_type_fixture =
      "id": @option_type_id 
      "name": "option_type_1"
      "value": "value_1"
      "created_at": "2012-10-30 17:19:40.500054"
      "updated_at": "2012-10-30 17:19:40.500054"
      "shop_id": App.current_shop
   
  it "should be defined", ->
    expect(@option_type).toBeDefined()

  it "can be instantiated", ->
    expect(@option_type).not.toBeNull()

  describe "check url", ->
    it "should return the URL", ->
      expect(@option_type.url()).toEqual(@option_type_url)

  describe "option_type save and fetch", ->
    beforeEach ->
      @server = sinon.fakeServer.create()
      @option_type_url_with_option_type_id = "#{@option_type_url}/#{@option_type_id}"
      @option_type = new App.OptionType(@option_type_fixture)
      @option_type.id = 1
      @server.respondWith(
        "PUT"
        @option_type_url_with_option_type_id,
        [
          200,
          {"Content-Type": "application.json"},
          @option_type_fixture.toString()
        ]
      )
      @eventSpy = sinon.spy()
      @option_type.save()

    afterEach ->
      @server.restore()

    it "should make a save request to the server", ->
      expect(@option_type.toJSON()).toEqual(@option_type_fixture)

    it "should request method PUT ?", ->
      expect(@server.requests[0].method).toEqual("PUT")

    it "should request url /facebook/shops/:shop_id/option_types/:id ?", ->
      expect(@server.requests[0].url).toEqual(@option_type_url_with_option_type_id)

    it "should request requestBody to equal with option_types_attributes ?", ->
      expect(JSON.parse(@server.requests[0].requestBody)).toEqual(@option_type.attributes)
