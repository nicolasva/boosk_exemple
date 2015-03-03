describe "Shop settings router", ->
  beforeEach ->
    App.current_shop = 1
    @translate = new Backbone.Model
    @shop = new Backbone.Model
    @account = new Backbone.Model

    @taxonomies = new Backbone.Collection
    @devises = new Backbone.Collection
    @option_types = new Backbone.Collection
    @shipping_methods = new Backbone.Collection
    @tax_rates = new Backbone.Collection
    @zones = new Backbone.Collection

    @taxonomiesStub = sinon.stub(App.Collections, 'Taxonomies').returns(@taxonomies)
    @devisesStub = sinon.stub(App.Collections, 'Devises').returns(@devises)
    @optionTypesStub = sinon.stub(App.Collections, 'ProductOptionTypes').returns(@option_types)
    @shippingMethodsStub = sinon.stub(App.Collections, 'ShippingMethods').returns(@shipping_methods)

    @taxRatesStub = sinon.stub(App.Collections, 'TaxRates').returns(@tax_rates)
    @zonesStub = sinon.stub(App.Collections, 'Zones').returns(@zones)

    @translateStub = sinon.stub(App, 'Translate').returns(@translate)
    @accountStub = sinon.stub(App, 'Account').returns(@account)
    @shopStub = sinon.stub(App, 'Shop').returns(@shop)

    @wizard = false
    @router = new App.Routers.ShopSettings()

  afterEach ->
    @taxonomiesStub.restore()
    @devisesStub.restore()
    @shopStub.restore()
    @translateStub.restore()
    @accountStub.restore()
    @optionTypesStub.restore()
    @shippingMethodsStub.restore()
    @taxRatesStub.restore()
    @zonesStub.restore()

  describe "initialize", ->

    it "wizard object should false", ->
      expect(@wizard).toBe(false)

    it "creates a taxonomies collection", ->
      expect(@taxonomiesStub).toHaveBeenCalledOnce()
      expect(@taxonomiesStub).toHaveBeenCalledWithExactly()

    it "creates a devises collection", ->
      expect(@devisesStub).toHaveBeenCalledOnce()
      expect(@devisesStub).toHaveBeenCalledWithExactly()

    it "creates a shop instance", ->
      expect(@translateStub).toHaveBeenCalledOnce()
      expect(@translateStub).toHaveBeenCalledWithExactly()

    it "creates a account instance", ->
      expect(@accountStub).toHaveBeenCalledOnce()
      expect(@accountStub).toHaveBeenCalledWithExactly()

    it "creates a option_types instance", ->
      expect(@optionTypesStub).toHaveBeenCalledOnce()
      expect(@optionTypesStub).toHaveBeenCalledWithExactly()

    it "creates a shipping_methods instance", ->
      expect(@shippingMethodsStub).toHaveBeenCalledOnce()
      expect(@shippingMethodsStub).toHaveBeenCalledWithExactly()

    it "creates a tax_rates instance", ->
      expect(@taxRatesStub).toHaveBeenCalledOnce()
      expect(@taxRatesStub).toHaveBeenCalledWithExactly()

    it "creates a zones instance", ->
      expect(@zonesStub).toHaveBeenCalledOnce()
      expect(@zonesStub).toHaveBeenCalledWithExactly()


  describe "routes", ->
    beforeEach ->
      @routes =
        "/settings/wizard:value" : "generalSettings"
        "/settings/menu" : "editMenu"
        "/settings/option_types" : "indexOptionTypes"
        "/settings/shipping_methods" : "indexShipping"
        "/settings/tax_rates" : "indexTaxRates"
        "/settings/payment": "editPayment"
        "/settings/status": "editStatus"

      @routeSpy = sinon.spy()
      try
        Backbone.history.start({silent:true, pushState:true})
      catch e
      @router.navigate("elsewhere")

    it "handles /settings route", ->
      expect(@router["routes"]["/settings/wizard:value"]).toEqual(@routes["/settings/wizard/:value"])

    it "handles /settings/menu route", ->
      expect(@router["routes"]["/settings/menu"]).toEqual(@routes["/settings/menu"])

    it "handles /settings/option_types route", ->
      expect(@router["routes"]["/settings/option_types"]).toEqual(@routes["/settings/option_types"])

    it "handles /settings/shipping_methods route", ->
      expect(@router["routes"]["/settings/shipping_methods"]).toEqual(@routes["/settings/shipping_methods"])

    it "handles /settings/tax_rates route", ->
      expect(@router["routes"]["/settings/tax_rates"]).toEqual(@routes["/settings/tax_rates"])

    it "handles /settings/payment route", ->
      expect(@router["routes"]["/settings/payment"]).toEqual(@routes["/settings/payment"])

    it "handles /settings/status route", ->
      expect(@router["routes"]["/settings/status"]).toEqual(@routes["/settings/status"])

    describe "generalSettings handler", ->
      beforeEach ->
        @shopFetchStub = sinon.stub(@shop, "fetch").yieldsTo("success", @shop)
        @translateFetchStub = sinon.stub(@translate, "fetch").yieldsTo("success", @translate)
        @devisesFetchStub = sinon.stub(@devises, "fetch").yieldsTo("success", @devises)
        @editShopViewStub = sinon.stub(App.Views.Shops, "Edit").returns(new Backbone.View())
        @popupViewStub = sinon.stub(App.Views, "Popup").returns(new Backbone.View())

      afterEach ->
        @shopFetchStub.restore()
        @editShopViewStub.restore()
        @popupViewStub.restore()
        @translateFetchStub.restore()
        @devisesFetchStub.restore()

      it "is fired visiting / route", ->
        @router.bind("route:generalSettings", @routeSpy)
        @router.navigate("#/settings/wizard=true", true)
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWithExactly("true")

      describe "mode wizard => false", ->
        beforeEach ->
          @router.generalSettings(false)
          @wizard = false

        it "fetches translate instance", ->
          expect(@translateFetchStub).toHaveBeenCalledOnce()

        it "fetches shop instance", ->
          expect(@shopFetchStub).toHaveBeenCalledOnce()

        it "fetches devises instance", ->
          expect(@devisesFetchStub).toHaveBeenCalledOnce()

        it "creates an edit shop view", ->
          expect(@editShopViewStub).toHaveBeenCalledOnce()
          expect(@editShopViewStub).toHaveBeenCalledWithExactly(model: @shop, translate: @translate, wizard: @wizard, devises: @devises)

      describe "mode wizard => true", ->
        beforeEach ->
          @router.generalSettings("true")
          @wizard = true

        it "fetches translate instance", ->
          expect(@translateFetchStub).toHaveBeenCalledOnce()

        it "fetches shop instance", ->
          expect(@shopFetchStub).toHaveBeenCalledOnce()

        it "fetches shop instance", ->
          expect(@devisesFetchStub).toHaveBeenCalledOnce()

        it "creates an edit shop view", ->
          expect(@editShopViewStub).toHaveBeenCalledOnce()
          expect(@editShopViewStub).toHaveBeenCalledWithExactly(model: @shop, translate: @translate, wizard: @wizard, devises: @devises)


    describe "option_types handler", ->
      beforeEach ->
        @translateFetchStub = sinon.stub(@translate, "fetch").yieldsTo("success", @translate)
        @shopFetchStub = sinon.stub(@shop, "fetch").yieldsTo("success", @shop)
        @optionTypesFetchStub = sinon.stub(@option_types, "fetch").yieldsTo("success", @option_types)
        @optionTypeViewStub = sinon.stub(App.Views.ProductOptionTypes, "Index").returns(new Backbone.View())
        @router.indexOptionTypes()

      afterEach ->
        @translateFetchStub.restore()
        @shopFetchStub.restore()
        @optionTypesFetchStub.restore()
        @optionTypeViewStub.restore()

      it "is fired visiting /option_types route", ->
        @router.bind("route:indexOptionTypes", @routeSpy)
        @router.navigate("#/settings/option_types", true)
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWithExactly()

      it "fetches translate instance", ->
        expect(@translateFetchStub).toHaveBeenCalledOnce()

      it "fetches shop instance", ->
        expect(@shopFetchStub).toHaveBeenCalledOnce()

      it "fetches option types instance", ->
        expect(@optionTypesFetchStub).toHaveBeenCalledOnce()

      it "creates an edit shop view", ->
        expect(@optionTypeViewStub).toHaveBeenCalledOnce()
        expect(@optionTypeViewStub).toHaveBeenCalledWithExactly(option_types: @option_types,translate: @translate,shop: @shop, wizard:@wizard)


    describe "shipping handler", ->
      beforeEach ->
        @translateFetchStub = sinon.stub(@translate, "fetch").yieldsTo("success", @translate)
        @shopFetchStub = sinon.stub(@shop, "fetch").yieldsTo("success", @shop)
        @shippingMethodsFetchStub = sinon.stub(@shipping_methods, "fetch").yieldsTo("success", @shipping_methods)
        @shippingMethodViewStub = sinon.stub(App.Views.ShippingMethods, "Index").returns(new Backbone.View())
        @router.indexShipping()

      afterEach ->
        @translateFetchStub.restore()
        @shopFetchStub.restore()
        @shippingMethodsFetchStub.restore()
        @shippingMethodViewStub.restore()

      it "is fired visiting /shipping_methods route", ->
        @router.bind("route:indexShipping", @routeSpy)
        @router.navigate("#/settings/shipping_methods", true)
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWithExactly()

      it "fetches translate instance", ->
        expect(@translateFetchStub).toHaveBeenCalledOnce()

      it "fetches shop instance", ->
        expect(@shopFetchStub).toHaveBeenCalledOnce()

      it "fetches shipping method instance", ->
        expect(@shippingMethodsFetchStub).toHaveBeenCalledOnce()

      it "creates an edit shop view", ->
        expect(@shippingMethodViewStub).toHaveBeenCalledOnce()
        expect(@shippingMethodViewStub).toHaveBeenCalledWithExactly(collection: @shipping_methods,translate: @translate,shop: @shop, wizard:@wizard)


    describe "tax rates handler", ->
      beforeEach ->
        @translateFetchStub = sinon.stub(@translate, "fetch").yieldsTo("success", @translate)
        @shopFetchStub = sinon.stub(@shop, "fetch").yieldsTo("success", @shop)
        @taxRatesFetchStub = sinon.stub(@tax_rates, "fetch").yieldsTo("success", @tax_rates)
        @zonesFetchStub = sinon.stub(@zones, "fetch").yieldsTo("success", @zones)
        @taxRateViewStub = sinon.stub(App.Views.TaxRates, "Index").returns(new Backbone.View())
        @router.indexTaxRates()

      afterEach ->
        @translateFetchStub.restore()
        @shopFetchStub.restore()
        @taxRatesFetchStub.restore()
        @zonesFetchStub.restore()
        @taxRateViewStub.restore()

      it "is fired visiting /tax_rates route", ->
        @router.bind("route:indexTaxRates", @routeSpy)
        @router.navigate("#/settings/tax_rates", true)
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWithExactly()

      it "fetches translate instance", ->
        expect(@translateFetchStub).toHaveBeenCalledOnce()

      it "fetches shop instance", ->
        expect(@shopFetchStub).toHaveBeenCalledOnce()

      it "fetches zones instance", ->
        expect(@zonesFetchStub).toHaveBeenCalledOnce()

      it "fetches tax_rates instance", ->
        expect(@taxRatesFetchStub).toHaveBeenCalledOnce()

      it "creates an edit shop view", ->
        expect(@taxRateViewStub).toHaveBeenCalledOnce()
        expect(@taxRateViewStub).toHaveBeenCalledWithExactly(collection: @tax_rates,zones: @zones,translate: @translate,shop: @shop, wizard:@wizard)



    describe "payment handler", ->
      beforeEach ->
        @translateFetchStub = sinon.stub(@translate, "fetch").yieldsTo("success", @translate)
        @shopFetchStub = sinon.stub(@shop, "fetch").yieldsTo("success", @shop)
        @accountFetchStub = sinon.stub(@account, "fetch").yieldsTo("success", @account)
        @editPayementViewStub = sinon.stub(App.Views.Payment, "Edit").returns(new Backbone.View())
        @router.editPayment()

      afterEach ->
        @translateFetchStub.restore()
        @shopFetchStub.restore()
        @accountFetchStub.restore()
        @editPayementViewStub.restore()

      it "is fired visiting /tax_rates route", ->
        @router.bind("route:editPayment", @routeSpy)
        @router.navigate("#/settings/payment", true)
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWithExactly()

      it "fetches translate instance", ->
        expect(@translateFetchStub).toHaveBeenCalledOnce()

      it "fetches shop instance", ->
        expect(@accountFetchStub).toHaveBeenCalledOnce()

      it "fetches zones instance", ->
        expect(@shopFetchStub).toHaveBeenCalledOnce()

      it "creates an edit shop view", ->
        expect(@editPayementViewStub).toHaveBeenCalledOnce()
        expect(@editPayementViewStub).toHaveBeenCalledWithExactly(model: @shop,translate: @translate,wizard:@wizard,account: @account)


