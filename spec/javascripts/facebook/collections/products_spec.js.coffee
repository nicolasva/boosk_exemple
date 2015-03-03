describe "Products collection", ->
  beforeEach ->
    @product_id = 1
    App.current_shop = 1
    @query = "testsearch"
    @product_url = "/"+App.ui()+"/shops/#{App.current_shop}/products/index/#{@query}"
    @products = new App.Collections.Products()
    @products.query = @query
    @product1_fixture = 
      "id": 1
      "uuid": "31f4ec81-3343-7b7a-ef94-d11e80fc913c"
      "slug": "test"
      "name": "test"
      "description": "test description produit 2"
      "permalink": "http://google.fr"
      "status": true
      "highlight": false
      "shop_id": App.current_shop
      "product_variants":[{
        "height": 44.4
        "is_master": true
        "price": 100.0
        "product_id": @product_id
        "sku": "LAC100"
        "weight": 133.14
        "width": 66.5
      }]
      "taxon_ids": []
    @product2_fixture =
      "id": 2
      "uuid": "32f4ec81-3543-8b1a-ef99-d11e80fc913c"
      "slug": "test"
      "name": "test"
      "description": "test description produit 2"
      "permalink": "http://boosket.com"
      "status": true
      "highlight": false
      "shop_id": App.current_shop
      "product_variants": [{
        "height": 49
        "is_master": true
        "price": 150.0
        "product_id": @product_id
        "sku": "LAC200"
        "weight": 150
        "width": 80
      }]
      "taxon_ids": []

  it "Shoud be defined", ->
    expect(App.Collections.Products).toBeDefined()

  it "Should return the product url", ->
    expect(@products.url()).toEqual(@product_url)

  it "Can be instantiated", ->
    expect(@products).not.toBeNull()


  describe '#fetch', ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe 'request', ->
      beforeEach ->
        @products.fetch()
      
      it "can be instantiated", ->
        expect(@products).not.toBeNull()

      it "requests length equal 1", ->
        expect(@server.requests.length).toEqual(1)

      it "requests method equal GET", ->
        expect(@server.requests[0].method).toEqual("GET")

      it "requests methods url equal /facebook/shops/1/products/index/testsearch", ->
        expect(@server.requests[0].url).toEqual(@product_url)

    describe "on success", ->
      beforeEach ->
        @response_products_fixture = 
          "products": [@product1_fixture, @product2_fixture]
        @server.respondWith(
          "GET",
          @product_url,
          [
            200,
            {"Content-type" : "application/json"},
            JSON.stringify(@response_products_fixture)
          ]
        )
        @products.fetch()
        @server.respond()

      describe "loaded tasks collection", ->
        it "loads all products", ->
          expect(@products.toJSON()[0]["products"].length).toEqual(2)

        describe "parses tasks from the responses", ->
          describe "response fro products1", ->
            it "response for products1 for id", ->
              expect(@products.toJSON()[0]["products"][0].id).toEqual(@product1_fixture.id)

            it "response for products1 for name", ->
              expect(@products.toJSON()[0]["products"][0].uuid).toEqual(@product1_fixture.uuid)
            
            it "response for products1 for slug", ->
              expect(@products.toJSON()[0]["products"][0].slug).toEqual(@product1_fixture.slug)

            it "responses for products1 for description", ->
              expect(@products.toJSON()[0]["products"][0].name).toEqual(@product1_fixture.name)

            it "responses for products for permalink", ->
              expect(@products.toJSON()[0]["products"][0].permalink).toEqual(@product1_fixture.permalink)

            it "response for products for status", ->
              expect(@products.toJSON()[0]["products"][0].status).toEqual(@product1_fixture.status)

            it "response for products for highlight", ->
              expect(@products.toJSON()[0]["products"][0].highlight).toEqual(@product1_fixture.highlight)

            it "response for products for shop_id", ->
              expect(@products.toJSON()[0]["products"][0].shop_id).toEqual(@product1_fixture.shop_id)

          describe "response for products2", ->
            it "response for products2 for id", ->
              expect(@products.toJSON()[0]["products"][1].id).toEqual(@product2_fixture.id)

            it "response for products1 for name", ->
              expect(@products.toJSON()[0]["products"][1].uuid).toEqual(@product2_fixture.uuid)
            
            it "response for products1 for slug", ->
              expect(@products.toJSON()[0]["products"][1].slug).toEqual(@product2_fixture.slug)

            it "responses for products1 for description", ->
              expect(@products.toJSON()[0]["products"][1].name).toEqual(@product2_fixture.name)

            it "responses for products for permalink", ->
              expect(@products.toJSON()[0]["products"][1].permalink).toEqual(@product2_fixture.permalink)

            it "response for products for status", ->
              expect(@products.toJSON()[0]["products"][1].status).toEqual(@product2_fixture.status)

            it "response for products for highlight", ->
              expect(@products.toJSON()[0]["products"][1].highlight).toEqual(@product2_fixture.highlight)

            it "response for products for shop_id", ->
              expect(@products.toJSON()[0]["products"][1].shop_id).toEqual(@product2_fixture.shop_id)
