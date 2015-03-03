describe "ProductVariantPicture Model", ->
  beforeEach ->
    App.current_shop = 1
    @id = 1
    @product_id = 1
    @product_variant_id = 1
    @namespace_facebook = "/"+App.ui()+"/"
    @url_shops = "shops/"
    @url_products = "/products/" 
    @url_product_variants = "/product_variants/"
    @url_product_variant_pictures = "/product_variant_pictures"
    @product_variant_pictures = new App.ProductVariantPicture()
    @product_variant_pictures.product_id = @product_id
    @product_variant_pictures.product_variant_id = @product_variant_id
    @product_variant_pictures_url = "#{@namespace_facebook}#{@url_shops}#{App.current_shop}#{@url_products}#{@product_id}#{@url_product_variants}#{@product_variant_id}#{@url_product_variant_pictures}"
    @product_variant_pictures_fixture =
      "id": @id
      "name": "test_product_variant_picture"
      "value": "value_test"
      "created_at": "2012-10-30 17:19:40.500054"
      "updated_at": "2012-10-30 17:19:40.500054"
      "shop_id": App.current_shop
    
  it "should be defined", ->
    expect(@product_variant_pictures).toBeDefined()

  it "can be instantiated", ->
    expect(@product_variant_pictures).not.toBeNull()

  describe "check url", ->
    it "should return the URL", ->
      expect(@product_variant_pictures.url()).toEqual(@product_variant_pictures_url)

  describe "ProductVariantPicture save and fetch", ->
    beforeEach ->
      @server = sinon.fakeServer.create()
      @product_variant_pictures_url_with_id = "#{@product_variant_pictures_url}/#{@id}"
      @product_variant_pictures = new App.ProductVariantPicture(@product_variant_pictures_fixture)
      @product_variant_pictures.product_id = @product_id
      @product_variant_pictures.product_variant_id = @product_variant_id
      @product_variant_pictures.id = @id
      @server.respondWith(
        "PUT"
        @product_variant_pictures_url_with_id,
        [
          200,
          {"Content-Type": "application/json"},
          @product_variant_pictures_fixture.toString()
        ]
      )
      @eventSpy = sinon.spy()
      @product_variant_pictures.save()
      
    afterEach ->
      @server.restore()

    it "should make a save request to the server", ->
      expect(@product_variant_pictures.toJSON()).toEqual(@product_variant_pictures_fixture)

    it "should request method PUT ?", ->
      expect(@server.requests[0].method).toEqual("PUT")


    it "should request url /facebook/shops/:shop_id/products/:product_id/product_variants/:product_variant_id/product_variant_pictures/:id ?", ->
      expect(@server.requests[0].url).toEqual(@product_variant_pictures_url_with_id)

    it "should request requestBody to equal with product_variant_pictures_attributes ?", ->
      expect(JSON.parse(@server.requests[0].requestBody)).toEqual(@product_variant_pictures.attributes)
