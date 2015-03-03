describe "Show View Productvariants Mobile", ->
  beforeEach ->
    App.Views.ProductVariants.Show.prototype.template = JST["app/assets/javascripts/mobile/templates/product_variants/show"]

    @product_variants = "product_variants":[{"created_at":"2013-01-02T10:08:16Z","deleted_at":null,"depth":null,"height":null,"id":2,"is_master":true,"price":"123.0","product_id":2,"quantity":0,"sku":"123","updated_at":"2013-01-08T16:30:06Z","weight":null,"width":null,"price_ttc":147.11,"option_types":[{"ar_association_key_name":2,"created_at":"2013-01-02T09:56:06Z","id":1,"name":"couleurs","shop_id":1,"updated_at":"2013-01-02T09:56:06Z","value":"orange"}],"pictures":[{"cached_path":"20130102-1107-50553-2835/Capture_d_e_cran_2012-08-24_a__17.49.38__2_.png","created_at":"2013-01-02T10:08:16Z","id":2,"is_master":true,"picture":{"url":"/uploads/product_variant_picture/picture/2/Capture_d_e_cran_2012-08-24_a__17.49.38__2_.png"},"product_variant_id":2,"updated_at":"2013-01-08T16:30:06Z"},{"cached_path":"20130108-1729-84372-2415/19039916.jpg-r_160_240-b_1_D6D6D6-f_jpg-q_x-20090109_011644.jpg","created_at":"2013-01-08T16:30:06Z","id":22,"is_master":false,"picture":{"url":"/uploads/product_variant_picture/picture/22/19039916.jpg-r_160_240-b_1_D6D6D6-f_jpg-q_x-20090109_011644.jpg"},"product_variant_id":2,"updated_at":"2013-01-08T16:30:06Z"},{"cached_path":"20130108-1729-84372-2387/1149.png","created_at":"2013-01-08T16:30:06Z","id":23,"is_master":false,"picture":{"url":"/uploads/product_variant_picture/picture/23/1149.png"},"product_variant_id":2,"updated_at":"2013-01-08T16:30:06Z"},{"cached_path":"20130108-1729-84372-3971/Capture_d_e_cran_2012-08-23_a__17.01.50.png","created_at":"2013-01-08T16:30:06Z","id":24,"is_master":false,"picture":{"url":"/uploads/product_variant_picture/picture/24/Capture_d_e_cran_2012-08-23_a__17.01.50.png"},"product_variant_id":2,"updated_at":"2013-01-08T16:30:06Z"},{"cached_path":"20130108-1730-84372-6620/Capture_d_e_cran_2012-10-12_a__16.41.49.png","created_at":"2013-01-08T16:30:06Z","id":25,"is_master":false,"picture":{"url":"/uploads/product_variant_picture/picture/25/Capture_d_e_cran_2012-10-12_a__16.41.49.png"},"product_variant_id":2,"updated_at":"2013-01-08T16:30:06Z"}]}]
    @viewsProductVariantsShow = new App.Views.ProductVariants.Show({product_variants: @product_variants})

  describe "instantiation", ->
    beforeEach ->
      @renderStub = sinon.stub(@viewsProductVariantsShow, 'render')

    afterEach ->
      @renderStub.restore()

    it "binds on '#box' element", ->
      expect(@viewsProductVariantsShow.$el.selector).toEqual("#box")
      
    it "renders immediately", ->
      @viewsProductVariantsShow.initialize
        product_variants: @product_variants
      expect(@renderStub).toHaveBeenCalledOnce()

  describe "events", ->
    it "handles correct events", ->
      expect(@viewsProductVariantsShow.events).toEqual
        "click .img_product_variant": "load_product_variant"
