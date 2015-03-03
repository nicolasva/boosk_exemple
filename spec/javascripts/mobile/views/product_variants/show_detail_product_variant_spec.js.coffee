describe "Show_detail_product_variants View products mobile", ->
  beforeEach ->
    App.Views.ProductVariants.ShowDetailProductVariants.prototype.template = JST["app/assets/javascripts/mobile/templates/products/show"]
    @product_variant_id = 1
    @product_id = 1
    @shop_id = 1
    @customization_id = 1
    @product_variant_id = 1
    @product_variant = new Backbone.Model
      created_at: "2013-01-02T09:57:10Z"
      deleted_at: null
      depth: null
      height: null
      id: @product_variant_id
      is_master: true
      price: "123.0"
      product_id: @product_id
      quantity: 12
      sku: "123"
      updated_at: "2013-01-08T14:01:31Z"
      weight: null
      width: null
      product:
        available_on: null
        created_at: "2013-01-02T09:57:10Z"
        deleted_at: null
        description: "description"
        highlight: false
        id: @product_id
        name: "test"
        permalink: "http://google.fr"
        position: 1
        shipping_category_id: null
        shipping_method_id: null
        shop_id: @shop_id
        slug: "test"
        status: true
        tax_rate_id: 1
        updated_at: "2013-01-08T14:01:31Z"
        uuid: "5f72913c-9284-330f-3f95-6caca18ef138"
        shop:
          baseline: "test"
          created_at: "2013-01-02T09:50:58Z"
          data_product_feed_url: ""
          description: "description"
          devise: "EUR"
          facebook_page_token: null
          facebook_status: true
          fan_page_id: null
          google_shopping_key: null
          google_shopping_status: false
          has_active_payement: true
          id: @shop_id
          mobile_status: true
          name: "test"
          paypal_ccount: "nicolas.vandenbogaerde@gmail.com"
          slug: "test"
          terms: ""
          tv_status: false
          updated_at: "2013-01-25T16:53:12Z"
          url_website: ""
          uuid: "566bacea-986e-c3d9-0ed6-2f39c2dd00e8"
          web_status: false
          customization:
            background_color_product_list: "#ECECEC"
            background_color_product_thumb: "#FFFFFF"
            background_color_shop: "#FFFFFF"
            background_color_sidebar: "#2F2F2F"
            background_color_sidebar_item: "#FFFFFF"
            baseline_color: "#1D4088"
            border_color: "#DADADA"
            color_link: "#3B5998"
            color_link_product: "#3B5998"
            color_text: "#000000"
            color_text_menu: "#FFFFFF"
            color_text_menu_hover: "#F77D00"
            color_text_product: "#F77D00"
            created_at: "2013-01-02T09:50:58Z"
            fan_access: false
            id: @customization_id
            logo:
              url: null
            products_grid: 4
            products_per_page: 8
            search_engine: false
            shop_id: @shop_id
            shutter:
              url: "/assets/fallback/shutter_default_en.jpg"
            teaser:
              url: "/assets/fallback/teaser_default_en.jpg"
            updated_at: "2013-01-02T09:55:34Z"
      option_types: []
      pictures: [{cached_path: "20130102-1215-52724-9243/Capture_d_e_cran_2012-09-25_a__16.26.22.png", created_at: "2013-01-02T11:16:01Z", is_master: true, picture: {url: "/uploads/product_variant_picture/picture/4/Capture_d_e_cran_2012-09-25_a__16.26.22.png"}, product_variant_id: @product_variant_id, updated_at: "2013-01-08T14:01:31Z"}]

    @product_variantStub = sinon.stub(App, "ProductVariant").returns(@product_variant)
    @fetchProduct_variantStub = sinon.stub(@product_variant, "fetch").yieldsTo(@product_variant)

    @viewsProductVariantsShowDetailProductVariants = new App.Views.ProductVariants.ShowDetailProductVariants({productVariant: @product_variant})
    
  afterEach ->
    @product_variantStub.restore()
    @fetchProduct_variantStub.restore()

  describe "instantiation", ->
    beforeEach ->
      @renderStub = sinon.stub(@viewsProductVariantsShowDetailProductVariants, 'render')

    afterEach ->
      @renderStub.restore()

    it "binds on '#app_mobile' element", ->
      expect(@viewsProductVariantsShowDetailProductVariants.$el.selector).toEqual('#app_mobile')

    it "renders immediately", ->
      @viewsProductVariantsShowDetailProductVariants.initialize
        productVariant: @product_variant
      expect(@renderStub).toHaveBeenCalledOnce()

  describe "events", ->
    it "handles correct events", ->
      expect(@viewsProductVariantsShowDetailProductVariants.events).toEqual
        "submit #form_add_to_cart": "add_to_cart_mobile"
        "click .img_product_variant": "change_product_variant"
        "click .see_more": "see_more_product_variant_pictures"
