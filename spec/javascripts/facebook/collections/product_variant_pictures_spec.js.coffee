describe "ProductVariantPictures collection", ->
  beforeEach ->
    App.current_shop = 1
    @product_id = 1
    @product_variant_id = 1
    @productVariant_url = "/"+App.ui()+"/shops/"+App.current_shop+"/products/"+@product_id+"/product_variants/"+@product_variant_id+"/product_variant_pictures"
    @productVariantsPictures = new App.Collections.ProductVariantPictures()
    @productVariantsPictures.product_id = @product_id
    @productVariantsPictures.product_variant_id = @product_variant_id
    @productVariantPictures1_fixture = 
      "id": 1
      "picture": "Photo1_du_02-11-12_a__18.11.jpg"
      "cached_path": "20121107-0950-6338-2504/Photo1_du_02-11-12_a__18.11.jpg"
      "is_master": true
      "created_at": "2012-11-07 08:50:16.774040"
      "updated_at": "2012-11-07 08:50:16.774040"
      "product_variant_id": 6
    @productVariantPictures2_fixture =
      "id": 2
      "picture": "Photo2_du_02-11-12_a__18.11.jpg"
      "cached_path": "20121107-0950-6338-2504/Photo2_du_02-11-12_a__18.11.jpg"
      "is_master": true
      "created_at": "2012-11-07 08:50:16.774040"
      "updated_at": "2012-11-07 08:50:16.774040"
      "product_variant_id": 6

  it "should be defined", ->
    expect(@productVariantsPictures).toBeDefined()

  it "should return the ProductVariants url", ->
    expect(@productVariantsPictures.url()).toEqual(@productVariant_url)

  it "Can be instantiated", ->
    expect(@productVariantsPictures).not.toBeNull()

  describe "fetch", ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe "request", ->
      beforeEach ->
        @productVariantsPictures.fetch()

      it "fetch ProductVariantsPictures test length requests", ->
        expect(@server.requests.length).toEqual(1)

      it "fetch ProductVariantsPictures test method", ->
        expect(@server.requests[0].method).toEqual('GET')

      it "fetch ProductVariantsPictures test url", ->
        expect(@server.requests[0].url).toEqual(@productVariant_url)

    describe "On success", ->
      beforeEach ->
        @response_productVariantsPictures_fixture = 
          "product_variant_pictures": [@productVariantPictures1_fixture, @productVariantPictures2_fixture]
        @server.respondWith(
          "GET",
          @productVariant_url,
          [
            200,
            {"Content-type" : "application.json"},
            JSON.stringify(@response_productVariantsPictures_fixture)
          ]
        )
        @productVariantsPictures.fetch()
        @server.respond()

      describe "loaded tasks collection", ->
        it "loads all productVariantsPictures", ->
          expect(@productVariantsPictures.toJSON()[0]["product_variant_pictures"].length).toEqual(2)

        describe "parses tasks from the responses", ->
          describe "response for response1", ->
            it "responses for productVariantsPictures1 for id", ->
              expect(@productVariantsPictures.toJSON()[0]["product_variant_pictures"][0].id).toEqual(@productVariantPictures1_fixture.id)

            it "responses for productVariantsPictures1 for picture", ->
              expect(@productVariantsPictures.toJSON()[0]["product_variant_pictures"][0].picture).toEqual(@productVariantPictures1_fixture.picture)

            it "respones for productVariantsPictures1 for cached_path", ->
              expect(@productVariantsPictures.toJSON()[0]["product_variant_pictures"][0].cached_path).toEqual(@productVariantPictures1_fixture.cached_path)

            it "responses for productVariantsPictures1 for is_master", ->
              expect(@productVariantsPictures.toJSON()[0]["product_variant_pictures"][0].is_master).toEqual(@productVariantPictures1_fixture.is_master)

            it "responses for productVariantsPictures1 for created_at", ->
              expect(@productVariantsPictures.toJSON()[0]["product_variant_pictures"][0].created_at).toEqual(@productVariantPictures1_fixture.created_at)

            it "responses for productVariantsPictures1 for updated_at", ->
              expect(@productVariantsPictures.toJSON()[0]["product_variant_pictures"][0].updated_at).toEqual(@productVariantPictures1_fixture.updated_at)

            it "responses for productVariantsPictures1 for product_variant_id", ->
              expect(@productVariantsPictures.toJSON()[0]["product_variant_pictures"][0].product_variant_id).toEqual(@productVariantPictures1_fixture.product_variant_id)

          describe "response for response2", ->
            it "responses for productVariantsPictures2 for id", ->
              expect(@productVariantsPictures.toJSON()[0]["product_variant_pictures"][1].id).toEqual(@productVariantPictures2_fixture.id)

            it "responses for productVariantsPictures2 for picture", ->
              expect(@productVariantsPictures.toJSON()[0]["product_variant_pictures"][1].picture).toEqual(@productVariantPictures2_fixture.picture)

            it "responses for productVariantsPictures2 for cached_path", ->
              expect(@productVariantsPictures.toJSON()[0]["product_variant_pictures"][1].cached_path).toEqual(@productVariantPictures2_fixture.cached_path)

            it "responses for productVariantsPictures2 for is_master", ->
              expect(@productVariantsPictures.toJSON()[0]["product_variant_pictures"][1].is_master).toEqual(@productVariantPictures2_fixture.is_master)

            it "responses for productVariantsPictures2 for created_at", ->
              expect(@productVariantsPictures.toJSON()[0]["product_variant_pictures"][1].created_at).toEqual(@productVariantPictures2_fixture.created_at)

            it "responses for productVariantsPictures1 for updated_at", ->
              expect(@productVariantsPictures.toJSON()[0]["product_variant_pictures"][1].updated_at).toEqual(@productVariantPictures1_fixture.updated_at)

            it "responses for productVariantsPictures1 for product_variant_id", ->
              expect(@productVariantsPictures.toJSON()[0]["product_variant_pictures"][1].product_variant_id).toEqual(@productVariantPictures1_fixture.product_variant_id)
