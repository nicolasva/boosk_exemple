describe "Show View Mobile", ->
  describe "Rendering", ->
    beforeEach ->
      App.Views.Products.Show.prototype.template = JST["mobile/templates/products/show"]
      App.Views.Products.Show.prototype.template_see_more_product_variant_pictures = JST["mobile/templates/product_variants/show"]
      App.Views.Products.Show.prototype.template_quantity_for_product_variant = JST["mobile/templates/product_variants/option_type_quantity"]
      @shop = new Backbone.Model({id: 1, uuid: "5550eae6-2e82-6350-3355-0cd81fa843aa", slug: "test", name: "test", url_website: "http://dfcdsxfcdsfdsfdsfds", devise: "EUR", has_active_payement: true, facebook_status: true, mobile_status: true, google_shopping_status: false, web_status: false, tv_status: false, created_at: "2012-10-29 11:21:56.760977", updated_at: "2012-10-30 16:29:08.345445", user_id: 1, products: [available_on: null, created_at: "2012-11-07T08:50:16Z", deleted_at: null, description: "test description produit" , highlight: false, id: 6, name: "test", permalink: "", shipping_category_id: null, shipping_method_id: 1, slug: "test", status: true, tax_rate_id: null, updated_at: "2012-11-07T08:50:16Z", uuid: "31f4ec81-3343-7b7a-ef94-d11e80fc913c"], customization: {products_per_page: 10}})
      @product = new Backbone.Model({id:1, uuid:"3b9ca953-8502-3505-658c-8c0d123fbc14", slug: "Product-name-1", name: "Product name 1", status: true, description: "Description content 1", permalink: "http://shop.boosket.com/product/1", shop_id:1, tax_rate_id: 1, shipping_method_id: 1, shipping_category_id: 1})
      @translate = new Backbone.Model
        views:
          product:
            new: 
              h1_step_1: "h1 step1"
            table:
              price: "price"
          frontend:
            products:
              choose_taxon: "Choose taxon"
              select_quantity: "Select Quantity"
              add_to_cart: "Add to cart"
              see_on_website: "See on website"

      @option_types = new Backbone.Model
        id: 1
        name: "option_types test 1"
        value: "value option_types"
        created_at: "2012-11-15T13:41:41Z"
        updated_at: "2012-11-15T13:41:41Z"
        shop_id: 1

      @product_variant = new Backbone.Model
        id: 1
        sku: 123
        price: 123
        quantity: 10
        weight: ""
        height: ""
        width: ""
        depth: ""
        deleted_at: ""
        is_master: true
        created_at: "2013-01-02 09:57:10.397266"
        updated_at: "2013-01-08 14:01:31.390825"
        product_id: 1

      @product_variants = new Backbone.Collection
        
      @option_typesStub = sinon.stub(App.Collections, 'OptionTypes').returns(@option_types)
      @fetchOption_types = sinon.stub(@option_types, 'fetch').yieldsTo('success', @option_types)
      @ShopStub = sinon.stub(App, "Shop").returns(@shop)
      #@getVariants_stub = sinon.stub(@product, "getVariants").returns(@product_variant)
      @productVariantStub = sinon.stub(App.Collections, "ProductVariants").returns(@product_variant) 
      @variant_option_types_stub = sinon.stub(@product_variant, "getOptionTypes").returns(@option_types)
      @FetchShopStub = sinon.stub(@shop, 'fetch').yieldsTo('success', @shop)
      @ProductStub = sinon.stub(App, "Product").returns(@product)
      @fetchProductStub = sinon.stub(@product, 'fetch').yieldsTo('success', @product)
      @translateStub = sinon.stub(App, "Translate") .returns(@translate)
      @fetchTranslateStub = sinon.stub(@translate, 'fetch').yieldsTo('success', @translate)

      @showview = new App.Views.Products.Show
        product: @product
        shop: @shop
        option_types: @option_types
        translate: @translate

    afterEach ->
      @productVariantStub.restore()
      @option_typesStub.restore()
      @ShopStub.restore()
      @product_variants_stub.restore()
      @ProductStub.restore()
      @translateStub.restore() 
      @fetchOption_types.restore()
      @FetchShopStub.restore()
      @fetchProductStub.restore()
      @fetchTranslateStub.restore()

    describe 'instantiation', ->
      beforeEach ->
        @renderStub = sinon.stub(@showview, 'render')

        afterEach ->
          @renderStub.restore()

      it "binds on '#app_mobile' element", ->
        console.log @showview



