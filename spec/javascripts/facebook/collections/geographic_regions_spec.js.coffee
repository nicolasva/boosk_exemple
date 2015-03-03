describe "GeographicRegions collection", ->
  beforeEach ->
    @geographic_regions_url = "/geographic_regions"
    @geographic_regions = new App.Collections.GeographicRegions()
    @geographic_region_fixture =
      "name":"Andorre",
      "code":"AD",
      "type":"country",
      "subregions":[{
        "name":"Canillo",
        "code":"AD|02",
        "type":"parish"},
        {
          "name":"Encamp",
          "code":"AD|03",
          "type":"parish"
        },
        {
          "name":"La Massana",
          "code":"AD|04",
          "type":"parish"
        },
        {
          "name":"Ordino",
          "code":"AD|05",
          "type":"parish"
        },
        {
          "name":"test",
          "code":"AD|06",
          "type":"parish"
        }]

  it "Should be defined", ->
    expect(App.Collections.GeographicRegions).toBeDefined()

  it "Should return the GeographicRegions url", ->
    expect(@geographic_regions.url()).toEqual(@geographic_regions_url)

  it "can be instantiated", ->
    expect(@geographic_regions).not.toBeNull()

  describe "fetch", ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe "request", ->
      beforeEach ->
        @geographic_regions.fetch()

      it "can be instantiated", ->
        expect(@geographic_regions).not.toBeNull()

      it "requests length equal 1", ->
        expect(@server.requests.length).toEqual(1)

      it "requests method equal GET", ->
        expect(@server.requests[0].method).toEqual("GET")

      it "requests method url equal /geographic_regions", ->
        expect(@server.requests[0].url).toEqual(@geographic_regions_url)

    describe "on success", ->
      beforeEach ->
        @response_geographic_regions_fixture = 
          "geographic_regions": [@geographic_region_fixture]
        @server.respondWith(
          "GET",
          @geographic_regions_url,
          [
            200,
            {"Content-type" : "application/json"},
            JSON.stringify(@response_geographic_regions_fixture)
          ]
        )
        @geographic_regions.fetch()
        @server.respond()

      describe "loaded tasks collection", ->
        it "loads all geographic_regions", ->
          expect(@geographic_regions.toJSON()[0]["geographic_regions"].length).toEqual(1)

        describe "loaded tasks from the responses", ->
          describe "response for geographic_regions", ->
            it "response for geographic_regions for code", ->
              expect(@geographic_regions.toJSON()[0]["geographic_regions"][0].code).toEqual(@geographic_region_fixture.code)

            it "response for geographic_regions for name", ->
              expect(@geographic_regions.toJSON()[0]["geographic_regions"][0].name).toEqual(@geographic_region_fixture.name)

