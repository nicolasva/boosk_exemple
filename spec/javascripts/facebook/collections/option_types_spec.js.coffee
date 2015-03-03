describe "OptionTypes collection", ->
  beforeEach ->
    App.current_shop = 1
    @optionType_url = "/"+App.ui()+"/shops/"+App.current_shop+"/option_types"
    @optionTypes = new App.Collections.OptionTypes()
    @option_types1_fixture = 
      "id": 1
      "name": "option_types_1"
      "value": "orange"
      "shop_id": 1
    @option_types2_fixture = 
      "id": 2
      "name": "option_types_2"
      "value": "red"
      "shop_id": 1

  it "should be defined", ->
    expect(@optionTypes).toBeDefined()

  it "should return the OptionTYpes url", ->
    expect(@optionTypes.url()).toEqual(@optionType_url)

  it "Can be instantiated", ->
    expect(@optionTypes).not.toBeNull()

  describe "fetch", ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe 'request', ->
      beforeEach ->
        @optionTypes.fetch()

      it 'fetch OptionTypes test length requests', ->
        expect(@server.requests.length).toEqual(1)

      it "fetch OptionTypes test method", ->
        expect(@server.requests[0].method).toEqual('GET')

      it "fetch OptionTypes test url", ->
        expect(@server.requests[0].url).toEqual(@optionType_url)

    describe "on success", ->
      beforeEach ->
        @response_optionTypes_fixture = 
          "option_types": [@option_types1_fixture, @option_types2_fixture]
        @server.respondWith(
          "GET",
          @optionType_url,
          [
            200,
            {"Content-type" : "application/json"},
            JSON.stringify(@response_optionTypes_fixture)
          ]
        )
        @optionTypes.fetch()
        @server.respond()

      describe "loaded tasks collection", ->
        it "loads all products", ->
          expect(@optionTypes.toJSON()[0]["option_types"].length).toEqual(2)

        describe "parses tasks from the responses", ->
          describe "response for response1", ->
            it "responses for optionTypes1 for id", -> 
              expect(@optionTypes.toJSON()[0]["option_types"][0].id).toEqual(@option_types1_fixture.id)

            it "responses for optionTypes1 for name", ->
              expect(@optionTypes.toJSON()[0]["option_types"][0].name).toEqual(@option_types1_fixture.name)

            it "responses for optionTypes1 for value", ->
              expect(@optionTypes.toJSON()[0]["option_types"][0].value).toEqual(@option_types1_fixture.value)

            it "responses for optionTypes1 for shop_id", ->
              expect(@optionTypes.toJSON()[0]["option_types"][0].shop_id).toEqual(@option_types1_fixture.shop_id)

          describe "response for response2", ->
            it "responses for optionTypes2 for id", ->
              expect(@optionTypes.toJSON()[0]["option_types"][1].id).toEqual(@option_types2_fixture.id)

            it "responses for optionTypes2 for name", ->
              expect(@optionTypes.toJSON()[0]["option_types"][1].name).toEqual(@option_types2_fixture.name)

            it "responses for optionTypes2 for value", ->
              expect(@optionTypes.toJSON()[0]["option_types"][1].value).toEqual(@option_types2_fixture.value)

            it "responses for optionTypes1 for shop_id", ->
              expect(@optionTypes.toJSON()[0]["option_types"][1].shop_id).toEqual(@option_types2_fixture.shop_id)
