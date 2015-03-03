describe "Product Router", ->
  beforeEach ->
    App.current_shop = 1
    @products = new Backbone.Collection
    @productsStub = sinon.stub(App.Collections, 'Products').returns(@products)

    @product = new Backbone.Model
    @productStub = sinon.stub(App, 'Product').returns(@product)

    @optionTypes = new Backbone.Collection
    @optionTypesStub = sinon.stub(App.Collections, 'ProductOptionTypes').returns(@optionTypes)

    @shops = new Backbone.Collection
    @shopsStub = sinon.stub(App.Collections, 'Shops').returns(@shops)

    @shop = new Backbone.Model
    @shopStub = sinon.stub(App, 'Shop').returns(@shop)

    @fetchShopsStub = sinon.stub(@shops, 'fetch').yieldsTo('success', @shops)
    @listShopViewStub = sinon.stub(App.Views, 'Listshop').returns(new Backbone.View)

    @translate = new Backbone.Model
    @translateStub = sinon.stub(App, 'Translate').returns(@translate)

    @router = new App.Routers.Products()

  afterEach ->
    @productsStub.restore()
    @productStub.restore()
    @optionTypesStub.restore()
    @shopsStub.restore()
    @shopStub.restore()
    @fetchShopsStub.restore()
    @listShopViewStub.restore()
    @translateStub.restore()

  describe "when initialized", ->
    it "creates a products collection", ->
      expect(@productsStub).toHaveBeenCalledOnce()
      expect(@productsStub).toHaveBeenCalledWithExactly()

    it "creates an option types collection", ->
      expect(@optionTypesStub).toHaveBeenCalledOnce()
      expect(@optionTypesStub).toHaveBeenCalledWithExactly()

    it "creates a shops collection", ->
      expect(@shopsStub).toHaveBeenCalledOnce()
      expect(@shopsStub).toHaveBeenCalledWithExactly()

    it "fetches shops collection", ->
      expect(@fetchShopsStub).toHaveBeenCalledOnce()

    it "creates a list shop view", ->
      expect(@listShopViewStub).toHaveBeenCalledOnce()
      expect(@listShopViewStub).toHaveBeenCalledWithExactly(shops: @shops, bsksession : @bsksession)

    it "creates a translate instance", ->
      expect(@translateStub).toHaveBeenCalledOnce()
      expect(@translateStub).toHaveBeenCalledWithExactly()

  describe "routes", ->
    beforeEach ->
      @routes =
        "/products": "index_product"
        "/products/new/step_1": "new_product_step_1"
        "/products/new/step_2": "new_product_step_2"
        "/products/new/step_3": "new_product_step_3"
        "/products/:id": "show"
        "/products/:id/edit": "edit"
        "/products/:product_id/variants/:variant_id/edit": "edit_variant"
      @product_id = 1
      @routeSpy = sinon.spy()
      try
        Backbone.history.start({silent:true, pushState:true})
      catch e
      @router.navigate("elsewhere")

    it "handles /products route", ->
      expect(@router["routes"]["/products"]).toEqual(@routes["/products"])

    it "handles /products/:id route", ->
      expect(@router["routes"]["/products/:id"]).toEqual(@routes["/products/:id"])

    it "handles /products/:id/edit route", ->
      expect(@router["routes"]["/products/:id/edit"]).toEqual(@routes["/products/:id/edit"])

    it "handles /products/:product_id/variants/:variant_id/edit route", ->
      expect(@router["routes"]["/products/:product_id/variants/:variant_id/edit"]).toEqual(@routes["/products/:product_id/variants/:variant_id/edit"])

    it "handles /products/new/step_1 route", ->
      expect(@router["routes"]["/products/new/step_1"]).toEqual(@routes["/products/new/step_1"])

    it "handles /products/new/step_2 route", ->
      expect(@router["routes"]["/products/new/step_2"]).toEqual(@routes["/products/new/step_2"])

    it "handles /products/new/step_3 route", ->
      expect(@router["routes"]["/products/new/step_3"]).toEqual(@routes["/products/new/step_3"])

    describe "index_product handler", ->
      beforeEach ->
        @fetchTranslateStub = sinon.stub(@translate, 'fetch').yieldsTo('success', @translate)
        @fetchProductsStub = sinon.stub(@products, 'fetch').yieldsTo('success', @products)
        @productsIndexViewStub = sinon.stub(App.Views.Products, 'Index').returns(new Backbone.View)

      afterEach ->
        @fetchTranslateStub.restore()
        @fetchProductsStub.restore()
        @productsIndexViewStub.restore()

      it "is fired visiting /products route", ->
        @router.bind("route:index_product", @routeSpy)
        @router.navigate("#/products", true)
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWithExactly()

      it "fetches translation", ->
        @router.index_product()
        expect(@fetchTranslateStub).toHaveBeenCalledOnce()

      it "fetches products collection", ->
        @router.index_product()
        expect(@fetchProductsStub).toHaveBeenCalledOnce()

      it "creates a products index view", ->
        @router.index_product()
        expect(@productsIndexViewStub).toHaveBeenCalledOnce()
        expect(@productsIndexViewStub).toHaveBeenCalledWithExactly(products: @products, translate: @translate)

    describe "show handler", ->
      beforeEach ->
        @fetchProductsStub = sinon.stub(@products, 'fetch').yieldsTo('success', @products)
        @product = new Backbone.Model
        @getProductStub = sinon.stub(@products, 'get').returns(@product)
        @productVariants = new Backbone.Collection
        @productsVariantsStub = sinon.stub(App.Collections, 'ProductVariants').returns(@productVariants)
        @resetProductVariantsStub = sinon.stub(@productVariants, 'reset')
        @getProductVariantsStub = sinon.stub(@product, 'get').returns([])
        @fetchOptionTypesStub = sinon.stub(@optionTypes, 'fetch').yieldsTo('success', @optionTypes)
        @showProductViewStub = sinon.stub(App.Views.Products, 'Show').returns(new Backbone.View)

      afterEach ->
        @fetchProductsStub.restore()
        @getProductStub.restore()
        @productsVariantsStub.restore()
        @resetProductVariantsStub.restore()
        @getProductVariantsStub.restore()
        @fetchOptionTypesStub.restore()
        @showProductViewStub.restore()

      it "is fired visiting /products/:id route", ->
        @router.bind("route:show", @routeSpy)
        @router.navigate("#/products/#{@product_id}", true)
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWithExactly("1")

      describe "when products have not been fetched yet", ->
        beforeEach ->
          @router.show("1")

        it "fetches products collection", ->
          expect(@fetchProductsStub).toHaveBeenCalledOnce()

        it "gets the good product", ->
          expect(@getProductStub).toHaveBeenCalledOnce()
          expect(@getProductStub).toHaveBeenCalledWithExactly("1")

        it "creates a product variants collection", ->
          expect(@productsVariantsStub).toHaveBeenCalledOnce()
          expect(@productsVariantsStub).toHaveBeenCalledWithExactly()

        it "resets product variants collection with current product variants", ->
          expect(@getProductVariantsStub).toHaveBeenCalledOnce()
          expect(@getProductVariantsStub).toHaveBeenCalledWithExactly('product_variants')
          expect(@resetProductVariantsStub).toHaveBeenCalledOnce()
          expect(@resetProductVariantsStub).toHaveBeenCalledWithExactly([])

        it "fetches option types collection", ->
          expect(@fetchOptionTypesStub).toHaveBeenCalledOnce()

        it "creates a product detail view", ->
          expect(@showProductViewStub).toHaveBeenCalledOnce()
          expect(@showProductViewStub).toHaveBeenCalledWithExactly(product: @product, product_variants: @productVariants, option_types: @optionTypes)

      describe "when products have already been fetched", ->
        beforeEach ->
          @products.add @product
          @router.show("1")

        it "does not fetch products collection", ->
          expect(@fetchProductsStub).not.toHaveBeenCalled()

        it "gets the good product", ->
          expect(@getProductStub).toHaveBeenCalledOnce()
          expect(@getProductStub).toHaveBeenCalledWithExactly("1")

        it "creates a product variants collection", ->
          expect(@productsVariantsStub).toHaveBeenCalledOnce()
          expect(@productsVariantsStub).toHaveBeenCalledWithExactly()

        it "resets product variants collection with current product variants", ->
          expect(@getProductVariantsStub).toHaveBeenCalledOnce()
          expect(@getProductVariantsStub).toHaveBeenCalledWithExactly('product_variants')
          expect(@resetProductVariantsStub).toHaveBeenCalledOnce()
          expect(@resetProductVariantsStub).toHaveBeenCalledWithExactly([])

        it "fetches option types collection", ->
          expect(@fetchOptionTypesStub).toHaveBeenCalledOnce()

        it "creates a product detail view", ->
          expect(@showProductViewStub).toHaveBeenCalledOnce()
          expect(@showProductViewStub).toHaveBeenCalledWithExactly(product: @product, product_variants: @productVariants, option_types: @optionTypes)

    describe "edit handler", ->
      beforeEach ->
        @fetchTranslateStub = sinon.stub(@translate, 'fetch')
        @fetchProductStub = sinon.stub(@product, 'fetch').yieldsTo('success', @product)
        @fetchOptionTypesStub = sinon.stub(@optionTypes, 'fetch').yieldsTo('success', @optionTypes)
        @editProductViewStub = sinon.stub(App.Views.Products, 'Edit').returns(new Backbone.View)

      afterEach ->
        @fetchTranslateStub.restore()
        @fetchProductStub.restore()
        @fetchOptionTypesStub.restore()
        @editProductViewStub.restore()

      it "is fired visiting /products/:id/edit route", ->
        @router.bind("route:edit", @routeSpy)
        @router.navigate("#/products/#{@product_id}/edit", true)
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWithExactly("1")

      describe "when products have not been fetched yet", ->
        beforeEach ->
          @router.edit("1")

        it "does fetch products collection", ->
          expect(@fetchProductStub).toHaveBeenCalledOnce()

        describe "and translations have already been fetched", ->
          beforeEach ->
            @translate.set(test: "test")
            @router.edit("1")

          it "fetches option types collection", ->
            expect(@fetchOptionTypesStub).toHaveBeenCalledOnce()

          it "creates an edit product view", ->
            expect(@editProductViewStub).toHaveBeenCalledOnce()
            expect(@editProductViewStub).toHaveBeenCalledWithExactly(product: @product, option_types: @optionTypes, translate: @translate, el: $("#app"))

        describe "and translations have not yet been fetched", ->
          beforeEach ->
            @fetchTranslateStub.yieldsTo('success', @translate)
            @router.edit("1")

          it "fetches option types collection", ->
            expect(@fetchOptionTypesStub).toHaveBeenCalledOnce()

          it "creates an edit product view", ->
            expect(@editProductViewStub).toHaveBeenCalledOnce()
            expect(@editProductViewStub).toHaveBeenCalledWithExactly(product: @product, option_types: @optionTypes, translate: @translate, el: $("#app"))

    describe "new_product_step_1 handler", ->
      beforeEach ->
        @product = new Backbone.Model
        @productsModelStub = sinon.stub(@products, 'model').returns(@product)
        @fetchShopStub = sinon.stub(@shop, 'fetch').yieldsTo('success', @shop)
        @fetchTranslateStub = sinon.stub(@translate, 'fetch').yieldsTo('success', @translate)
        @fetchOptionTypesStub = sinon.stub(@optionTypes, 'fetch').yieldsTo('success', @optionTypes)
        @step1ViewStub = sinon.stub(App.Views.Products.New, 'Step1').returns(new Backbone.View)

      afterEach ->
        @productsModelStub.restore()
        @fetchTranslateStub.restore()
        @fetchOptionTypesStub.restore()
        @step1ViewStub.restore()
        @fetchShopStub.restore()

      it "is fired visiting /products/new/step_1 route", ->
        @router.bind("route:new_product_step_1", @routeSpy)
        @router.navigate("#/products/new/step_1", true)
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWithExactly()

      describe "when translation has not been fetched yet", ->
        beforeEach ->
          @router.new_product_step_1()

        it "fetches translations", ->
          expect(@fetchTranslateStub).toHaveBeenCalledOnce()

        it "fetches translations", ->
          expect(@fetchShopStub).toHaveBeenCalledOnce()

        it "fetches option types", ->
          expect(@fetchOptionTypesStub).toHaveBeenCalledOnce()

        it "creates a step_1 view", ->
          expect(@step1ViewStub).toHaveBeenCalledOnce()
          expect(@step1ViewStub).toHaveBeenCalledWithExactly(product: @product, option_types: @optionTypes, translate: @translate, shop: @shop)

    describe "new_product_step_2 handler", ->
      beforeEach ->
        @productVariants = sinon.stub(App.Collections, 'ProductVariants')
        @router.new_product = new Backbone.Model
        @step2ViewStub = sinon.stub(App.Views.Products.New, 'Step2').returns(new Backbone.View)

      afterEach ->
        @productVariants.restore()
        @step2ViewStub.restore()

      it "is fired visiting /products/new/step_2 route", ->
        @router.bind("route:new_product_step_2", @routeSpy)
        @router.navigate("#/products/new/step_2", true)
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWithExactly()

      it "creates a step_2 view", ->
        @router.new_product_step_2()
        expect(@step2ViewStub).toHaveBeenCalledOnce()
        expect(@step2ViewStub).toHaveBeenCalledWithExactly
          product: @router.new_product
          option_types: @optionTypes
          product_variants: @router.new_product_variants
          translate: @translate

    describe "new_product_step_3 handler", ->
      beforeEach ->
        @router.new_product = new Backbone.Model
        @router.new_product_variants = new Backbone.Collection
        @step3ViewStub = sinon.stub(App.Views.Products.New, 'Step3').returns(new Backbone.View)

      afterEach ->
        @step3ViewStub.restore()

      it "is fired visiting /products/new/step_3", ->
        @router.bind("route:new_product_step_3", @routeSpy)
        @router.navigate("#/products/new/step_3", true)
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWithExactly()

      it "creates a step_3 view", ->
        @router.new_product_step_3()
        expect(@step3ViewStub).toHaveBeenCalledOnce()
        expect(@step3ViewStub).toHaveBeenCalledWithExactly
          product: @router.new_product
          option_types: @optionTypes
          product_variants: @router.new_product_variants
          translate: @translate
