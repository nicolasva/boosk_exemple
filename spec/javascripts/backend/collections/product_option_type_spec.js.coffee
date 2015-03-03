describe "ProductOptionType collection", ->
  beforeEach ->
   App.current_shop = 1
   @productoptiontype_url = "/shops/#{App.current_shop}/option_types"
   @productoptiontypes = new App.Collections.ProductOptionTypes()
   @productoptiontype1_fixture =
     "id": 1 
     "name": "test option_types name1"
     "value": "test value option_types2"
     "shop_id": App.current_shop
   @productoptiontype2_fixture = 
     "id": 2
     "name": "test option_types name2"
     "value": "test value option_types2"
     "shop_id": App.current_shop

  it "should be defined", -> 
    expect(App.Collections.ProductOptionTypes).toBeDefined()

  it "should return the productoptiontype url", ->
    expect(@productoptiontypes.url()).toEqual(@productoptiontype_url)

  it "Can be instantiated", ->
    expect(@productoptiontypes).not.toBeNull()

  describe '#fetch', ->
    beforeEach ->
      @server = sinon.fakeServer.create() 

    afterEach ->
      @server.restore()
    
    describe 'request', ->
      beforeEach ->
        @request = @server.requests[0]

      it "fetch product", ->
        @productoptiontypes.fetch()

    describe "on success", ->
      beforeEach ->
        @response_productoptiontypes_fixture = 
          "option_types": [@productoptiontype1_fixture, @productoptiontype2_fixture]
        @server.respondWith(
          "GET",
          @productoptiontype_url,
          [
            200,
            {"Content-type" : "application/json"},
            JSON.stringify(@response_productoptiontypes_fixture)
          ]
        )
        @productoptiontypes.fetch()
        @server.respond()

      describe "loaded tasks collection", ->
        it "loads all tasks ?", ->
          expect(@productoptiontypes.toJSON()[0]["option_types"].length).toEqual(2)
   
        describe "parses tasks form the responses", ->
          it "response for productoptiontype1", ->
            expect(@productoptiontypes.toJSON()[0]["option_types"][0].id).toEqual(@productoptiontype1_fixture.id)
            expect(@productoptiontypes.toJSON()[0]["option_types"][0].name).toEqual(@productoptiontype1_fixture.name)
            expect(@productoptiontypes.toJSON()[0]["option_types"][0].value).toEqual(@productoptiontype1_fixture.value)
            expect(@productoptiontypes.toJSON()[0]["option_types"][0].shop_id).toEqual(@productoptiontype1_fixture.shop_id)

          it "response for productoptiontype2", ->
            expect(@productoptiontypes.toJSON()[0]["option_types"][1].id).toEqual(@productoptiontype2_fixture.id)
            expect(@productoptiontypes.toJSON()[0]["option_types"][1].name).toEqual(@productoptiontype2_fixture.name)
            expect(@productoptiontypes.toJSON()[0]["option_types"][1].value).toEqual(@productoptiontype2_fixture.value)
            expect(@productoptiontypes.toJSON()[0]["option_types"][1].shop_id).toEqual(@productoptiontype2_fixture.shop_id)
