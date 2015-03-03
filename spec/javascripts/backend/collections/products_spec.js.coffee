describe "Products collection", ->
  beforeEach ->
    @product_id = 1
    App.current_shop = "3c256d22-5628-4e56-bdb0-886170203c23"
    @product_url = "/shops/#{App.current_shop}/products?page=1&perPage=10"
    @products = new App.Collections.Products()
    @product1_fixture =
      "id":1
      "permalink": "http://lacoste.fr"
      "shop_id":App.current_shop
      "status":1
      "product_variants":[{
        "height":44.4
        "is_master":true
        "price":100.8
        "product_id":@product_id
        "sku":"LAC100"
        "weight": 133.14
        "width": 66.5
      }]
      "taxon_ids": []
    @product2_fixture =
      "id":2
      "permalink":"http://boosket.com"
      "shop_id":1
      "product_variants":[{
        "height":44.20
        "is_master":true
        "price":5.5
        "product_id":@product_id
        "sku": "LAC200"
        "weight": "20.7"
        "width": "78"
      }]
      "taxon_ids": []

  it "should be defined", ->
    expect(App.Collections.Products).toBeDefined()

  it "should return the product url", ->
    expect(@products.url()).toEqual(@product_url)

  it "Can be instantiated", ->
    expect(@products).not.toBeNull()

  describe '#fetch', ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe 'request', ->
      it "fetch product", ->
        @products.fetch()
        expect(@server.requests.length).toEqual(1)
        expect(@server.requests[0].method).toEqual("GET")
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
          expect(@products.length).toEqual(2)

        describe "parses tasks form the responses", ->
          it "response for product1", ->
            expect(@products.toJSON()[0].id).toEqual(@product1_fixture.id)
            expect(@products.toJSON()[0].name).toEqual(@product1_fixture.name)
            expect(@products.toJSON()[0].permalink).toEqual(@product1_fixture.permalink)
            expect(@products.toJSON()[0].shop_id).toEqual(App.current_shop)
            expect(@products.toJSON()[0].status).toEqual(@product1_fixture.status)
            expect(@products.toJSON()[0]["product_variants"][0].height).toEqual(@product1_fixture["product_variants"][0].height)
            expect(@products.toJSON()[0]["product_variants"][0].is_master).toEqual(@product1_fixture["product_variants"][0].is_master)
            expect(@products.toJSON()[0]["product_variants"][0].price).toEqual(@product1_fixture["product_variants"][0].price)
            expect(@products.toJSON()[0]["product_variants"][0].product_id).toEqual(@product_id)
            expect(@products.toJSON()[0]["product_variants"][0].sku).toEqual(@product1_fixture["product_variants"][0].sku)
            expect(@products.toJSON()[0]["product_variants"][0].weight).toEqual(@product1_fixture["product_variants"][0].weight)
            expect(@products.toJSON()[0]["product_variants"][0].width).toEqual(@product1_fixture["product_variants"][0].width)

          it "response for product2", ->
            expect(@products.toJSON()[1].id).toEqual(@product2_fixture.id)
            expect(@products.toJSON()[1].name).toEqual(@product2_fixture.name)
            expect(@products.toJSON()[1].permalink).toEqual(@product2_fixture.permalink)
            expect(@products.toJSON()[1].status).toEqual(@product2_fixture.status)
            expect(@products.toJSON()[1]["product_variants"][0].height).toEqual(@product2_fixture["product_variants"][0].height)
            expect(@products.toJSON()[1]["product_variants"][0].is_master).toEqual(@product2_fixture["product_variants"][0].is_master)
            expect(@products.toJSON()[1]["product_variants"][0].price).toEqual(@product2_fixture["product_variants"][0].price)
            expect(@products.toJSON()[1]["product_variants"][0].product_id).toEqual(@product_id)
            expect(@products.toJSON()[1]["product_variants"][0].sku).toEqual(@product2_fixture["product_variants"][0].sku)
            expect(@products.toJSON()[1]["product_variants"][0].weight).toEqual(@product2_fixture["product_variants"][0].weight)
            expect(@products.toJSON()[1]["product_variants"][0].width).toEqual(@product2_fixture["product_variants"][0].width)
