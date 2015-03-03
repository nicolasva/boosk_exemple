describe "ProductVariants collection", ->
  beforeEach ->
    @attributes = 
      "product_id":1
    App.current_shop = 1
    @url_shop = "/shops/"
    @url_product = "/products/"
    @product_id = 1
    #@attributes.product_id = 1
    #@attributes.product_variant.product_id = 1
    @url_product_variants = "/product_variants"
    @productvariant_url = "#{@url_shop}#{App.current_shop}#{@url_product}#{@product_id}#{@url_product_variants}"
    @productvariants = new App.Collections.ProductVariants()
         
  it 'should be defined', ->
    expect(App.Collections.ProductVariants).toBeDefined()

  it 'should return the product_variant url', ->
    productvariants = @productvariants
    productvariants.url = @productvariant_url
    expect(productvariants.url).toEqual(@productvariant_url)

  it "Can be instantiated", ->
    expect(@productvariants).not.toBeNull()  

  describe "when instantiated with model literal", ->
    beforeEach ->
        @model = new Backbone.Model({id: 3, sku: 1234, price: 456, weight: 550, height: 78, width: 430, is_master: true, product_id: @product_id})
        @productvariants.add(@model)
    
    it "should have 1 ProductVariant model", ->
      expect(@productvariants.length).toEqual(1)

    it "response for productvariants", ->
      expect(@productvariants.toJSON()[0].id).toEqual(@model.id)
      expect(@productvariants.toJSON()[0].sku).toEqual(@model.get("sku"))
      expect(@productvariants.toJSON()[0].price).toEqual(@model.get("price"))
      expect(@productvariants.toJSON()[0].weight).toEqual(@model.get("weight"))
      expect(@productvariants.toJSON()[0].height).toEqual(@model.get("height"))
      expect(@productvariants.toJSON()[0].width).toEqual(@model.get("width"))
      expect(@productvariants.toJSON()[0].is_master).toEqual(@model.get("is_master"))
      expect(@productvariants.toJSON()[0].product_id).toEqual(@model.get("product_id"))
