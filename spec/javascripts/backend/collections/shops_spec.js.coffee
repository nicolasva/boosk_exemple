describe "Shops collection", ->
  it "should be defined", ->
    expect(App.Collections.Shops).toBeDefined()

  beforeEach ->
    @url = "/shops"
    @user_id = 1
    @shop1_fixture =
      "id":1
      "name": "name_baseline1"
      "description": "description shop1"
      "user_id":@user_id
    @shop2_fixture =
      "id":2
      "name": "name_baseline2"
      "description": "description shop1"
      "user_id":@user_id
    @shops = new App.Collections.Shops()

  it "should return the shop url", ->
      expect(@shops.url).toEqual(@url)

  it "Can be instantiated", ->
    expect(@shops).not.toBeNull()

  describe '#fetch', ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe 'request', ->
      beforeEach ->
        @request = @server.requests[0]

      it "fetch shop", ->
        @shops.fetch()

    describe "on success", ->
      beforeEach ->
        @response_shops_fixture =
          "shops": [@shop1_fixture, @shop2_fixture]
        @server.respondWith(
          "GET",
          @url,
          [
            200,
            {"Content-type" : "application/json"},
            JSON.stringify(@response_shops_fixture)
          ]
        )
        @shops.fetch()
        @server.respond()

      describe "loaded tasks collection", ->
        it "loads all tasks", ->
          expect(@shops.toJSON()[0]["shops"].length).toEqual(2)

        describe "parses tasks from the responses", ->
          it "response for shop1", ->
            expect(@shops.toJSON()[0]["shops"][0].id).toEqual(@shop1_fixture.id)
            expect(@shops.toJSON()[0]["shops"][0].name).toEqual(@shop1_fixture.name)
            expect(@shops.toJSON()[0]["shops"][0].description).toEqual(@shop1_fixture.description)
            expect(@shops.toJSON()[0]["shops"][0].user_id).toEqual(@user_id)
          it "response for shop2", ->
            expect(@shops.toJSON()[0]["shops"][1].id).toEqual(@shop2_fixture.id)
            expect(@shops.toJSON()[0]["shops"][1].name).toEqual(@shop2_fixture.name)
            expect(@shops.toJSON()[0]["shops"][1].description).toEqual(@shop2_fixture.description)
