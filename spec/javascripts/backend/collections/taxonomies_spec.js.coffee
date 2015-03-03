describe 'Taxonomies collection', ->
  beforeEach ->
    @taxonomy_id = 1
    App.current_shop = 1
    @taxonomies_url = "/shops/#{App.current_shop}/taxonomies"
    @taxonomies = new App.Collections.Taxonomies()
    @taxonomy1_fixture = 
      id: 1
      name: 'Taxonomy 1'
      shop_id: App.current_shop
    @taxonomy2_fixture = 
      id: 2
      name: 'Taxonomy 2'
      shop_id: App.current_shop

  it "should be defined", ->
    expect(App.Collections.Taxonomies).toBeDefined()

  it "should return the product url", ->
    expect(@taxonomies.url()).toEqual(@taxonomies_url)

  it "Can be instantiated", ->
    expect(@taxonomies).not.toBeNull()

  describe '#fetch', ->
    beforeEach ->
      @server = sinon.fakeServer.create()
  
    afterEach ->
      @server.restore()

    describe 'request', ->
      it "fetch taxonomies", ->
        @taxonomies.fetch()
        expect(@server.requests.length).toEqual(1)
        expect(@server.requests[0].method).toEqual("GET")
        expect(@server.requests[0].url).toEqual(@taxonomies_url)

    describe "on success", ->
      beforeEach ->
        @response_taxonomies_fixture =
          [@taxonomy1_fixture, @taxonomy2_fixture]
        @server.respondWith(
          "GET",
          @taxonomies_url,
          [
            200,
            {"Content-type" : "application/json"},
            JSON.stringify(@response_taxonomies_fixture)
          ]
        )
        @taxonomies.fetch()
        @server.respond()

      describe "loaded taxonomies collection", ->
        it "loads all taxonomies", ->
          expect(@taxonomies.length).toEqual(2)

        describe "parses taxonomies form the responses", ->
          it "response for taxonomy1", ->
            expect(@taxonomies.toJSON()[0].id).toEqual(@taxonomy1_fixture.id)
            expect(@taxonomies.toJSON()[0].name).toEqual(@taxonomy1_fixture.name)
            expect(@taxonomies.toJSON()[0].shop_id).toEqual(App.current_shop)

          it "response for taxonomy2", ->
            expect(@taxonomies.toJSON()[1].id).toEqual(@taxonomy2_fixture.id) 
            expect(@taxonomies.toJSON()[1].name).toEqual(@taxonomy2_fixture.name)
            expect(@taxonomies.toJSON()[1].shop_id).toEqual(App.current_shop)