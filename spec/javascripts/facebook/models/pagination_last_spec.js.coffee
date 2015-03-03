describe "PaginationLast Model", ->
  beforeEach ->
    App.current_shop = 1
    @paginationfirst_id = 1
    @id = 2
    @namespace_facebook = "/"+App.ui()
    @url_shops = "/shops/"
    @url_paginationfirsts = "/pagination_firsts/"
    @url_paginationlasts = "/pagination_lasts/"
    @pagination_last_url = "#{@namespace_facebook}#{@url_shops}#{App.current_shop}#{@url_paginationfirsts}#{@paginationfirst_id}#{@url_paginationlasts}#{@id}"
    @pagination_last = new App.PaginationLast()
    @pagination_last.paginationfirst_id = @paginationfirst_id
    @pagination_last.id = @id
    #"product_variant_id":6,"updated_at":}],"option_types":[]}]}
    @pagination_last_fixture = 
      "available_on": null,
      "created_at": "2012-11-07T08:50:16Z"
      "deleted_at": null,
      "description": "test description produit",
      "highlight": false,
      "id": 6,
      "name": "test-name",
      "permalink": "http://google.fr",
      "shipping_category_id": null,
      "shipping_method_id": null,
      "shop_id": App.current_shop,
      "slug": "test-name"
      "status": true,
      "tax_rate_id": null,
      "updated_at": "2012-11-07T08:50:16Z",
      "uuid": "31f4ec81-3343-7b7a-ef94-d11e80fc913c",
      "product_variants": [{
        "created_at": "2012-11-07T08:50:16Z",
        "deleted_at": null,
        "depth": null,
        "height": null,
        "id": 6,
        "is_master": true,
        "price": "123.0",
        "product_id": 6,
        "quantity": 34,
        "sku": 450
        "updated_at": "2012-11-07T08:50:16Z",
        "weight": null,
        "width": null,
        "price_ttc": "123.0",
        "pictures": [{
          "cached_path": "20121107-0950-6338-2504/Photo_du_02-11-12_a__18.11.jpg",
          "created_at": "2012-11-07T08:50:16Z",
          "id": 6,
          "is_master": true,
          "picture":
            "url": "/uploads/product_variant_picture/picture/6/Photo_du_02-11-12_a__18.11.jpg",
          "product_variant_id": 6,
          "updated_at": "2012-11-18T17:56:47Z",
        },
        {
          "cached_path": "20121118-1856-8431-7984/Capture_d_e_cran_2012-08-24_a__17.50.21.png",
          "created_at":"2012-11-18T17:56:47Z",
          "id": 11,
          "is_master": false,
          "picture":
            "url": "/uploads/product_variant_picture/picture/11/Capture_d_e_cran_2012-08-24_a__17.50.21.png",
          "product_variant_id": 6,
          "updated_at": "2012-11-18T17:56:47Z", 
        },
        {
          "cached_path": "20121118-1856-8431-2071/Capture_d_e_cran_2012-09-04_a__17.36.39.png",
          "created_at": "2012-11-18T17:56:47Z",
          "id": 12,
          "is_master": false,
          "picture":
            "url": "/uploads/product_variant_picture/picture/12/Capture_d_e_cran_2012-09-04_a__17.36.39.png",
          "product_variant_id": 6
          "updated_at": "2012-11-18T17:56:47Z",
        }],
        "option_types": []
      }]

  it "should be defined", ->
    expect(@pagination_last).toBeDefined()

  it "can be instantiated", ->
    expect(@pagination_last).not.toBeNull()

  describe "check url", ->
    it "should return the URL", ->
      expect(@pagination_last.url()).toEqual(@pagination_last_url)

  describe "pagination_last save and fetch", ->
    beforeEach ->
      @server = sinon.fakeServer.create()
      @pagination_last = new App.PaginationLast(@pagination_last_fixture)
      @pagination_last.paginationfirst_id = @paginationfirst_id
      @pagination_last.id = @id
      @server.respondWith(
        "POST"
        @pagination_last_url,
        [
          200,
          {"Content-Type": "application/json"},
          @pagination_last_fixture.toString()
        ]
      )
      @eventSpy = sinon.spy()
      @pagination_last.save()

    afterEach ->
      @server.restore()

    it "should make a save request to the server", ->
      expect(@pagination_last.toJSON()).toEqual(@pagination_last_fixture)

    it "should request method GET ?", ->
      expect(@server.requests[0].method).toEqual("PUT")

    it "should request url /facebook/shops/:shop_id/paginationfirsts/:paginationfirst_id/paginationlasts/:id", ->
      expect(@server.requests[0].url).toEqual(@pagination_last_url)

    it "should request requestBody to equal with pagination_last_attributes", ->
      expect(JSON.parse(@server.requests[0].requestBody)).toEqual(@pagination_last.attributes)











