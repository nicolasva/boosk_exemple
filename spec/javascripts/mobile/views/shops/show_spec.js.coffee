describe "shop view", ->
  beforeEach ->
    App.Views.Shops.Show.prototype.template = JST["app/assets/javascripts/mobile/templates/shop/show"]
    App.Views.Shops.Show.prototype.template_show_next = JST['app/assets/javascripts/mobile/templates/infinity/show_next']
    @shop1 = new Backbone.Model({id: 1, uuid: "5550eae6-2e82-6350-3355-0cd81fa843aa", slug: "test", name: "test", url_website: "http://dfcdsxfcdsfdsfdsfds", devise: "EUR", has_active_payement: true, facebook_status: true, mobile_status: true, google_shopping_status: false, web_status: false, tv_status: false, created_at: "2012-10-29 11:21:56.760977", updated_at: "2012-10-30 16:29:08.345445", user_id: 1, products: [available_on: null, created_at: "2012-11-07T08:50:16Z", deleted_at: null, description: "test description produit" , highlight: false, id: 6, name: "test", permalink: "", shipping_category_id: null, shipping_method_id: 1, slug: "test", status: true, tax_rate_id: null, updated_at: "2012-11-07T08:50:16Z", uuid: "31f4ec81-3343-7b7a-ef94-d11e80fc913c"], customization: {products_per_page: 10}})

    @translate = new Backbone.Model
      show: "Show" 

    @shopStub = sinon.stub(App, "Shop").returns(@shop1)
    @fetchShopStub = sinon.stub(@shop1, 'fetch').yieldsTo(@shop1)
    @translateStub = sinon.stub(App, "Translate").returns(@translate)
    @fetchTranslateStub = sinon.stub(@translate, 'fetch').yieldsTo(@translate)
    @showview = new App.Views.Shops.Show({shop: @shop1, translate: @translate})

  afterEach ->
    @shopStub.restore()
    @fetchShopStub.restore()
    @translateStub.restore()
    @fetchTranslateStub.restore()

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@showview, 'render')

    afterEach ->
      @renderStub.restore()

    it "binds on '.product_lists' element", ->
      expect(@showview.$el.selector).toEqual("#app_mobile")

    it "renders immediately", ->
      @showview.initialize
        shop: @shop1 
        translate: @translate
      expect(@renderStub).toHaveBeenCalledOnce()

  describe "Rendering", ->
    beforeEach ->
      sinon.spy(Haml, 'render')
      sinon.spy(@showview, 'template')
      @showview.render()

    afterEach ->
       Haml.render.restore()
       @showview.template.restore()

  describe "events", ->
    it "handles correct events", ->
      expect(@showview.events).toEqual
        "click .product_thumb" : "show_product"
