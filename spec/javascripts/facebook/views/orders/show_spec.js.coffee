describe "Show View Facebook", ->
  beforeEach ->
    @showview = App.Views.Orders.Show

  describe "Rendering", ->
    beforeEach ->
      @backboneView = new Backbone.View
      @backboneRenderSpy = sinon.spy(@backboneView, "render")
      @backboneViewStub = sinon.stub(window['App.Views.Orders.Show']).returns(@backboneView)
      @backboneModel1 = new Backbone.Model({address_id: 1, credit_total: 123, email: "nicolas.vandenbogaerde@gmail.com", id: 1, item_total: 1, number: 123, order_id: 1, paid: false, payment_state: "fr", payment_total: 123, shop_id: 1, special_instructions: "Special instructions", state_id: 1, total: 1234.0, address: {city: "PANTIN", country_id: 1, designation: "Test_nicolas", firstname: "Nicolas", id: 1, lastname: "VANDENBOGAERDE", state_id: 1, zip_code: "93500"}, shop: {created_at: "012-05-22T08:12:10Z", devise: "EUR", id:1, name: "VANDENBOGAERDE", status: true, updated_at: "2012-05-22T08:12:10Z", user_id: 1, uuid: "0287a72a-a55d-eedc-b7e8-6fc9ff3c1764"}, line_items:[{id: 1, order_id: 1, price: 123, product_variant_id: 1, quantity: 123, product_variant:{created_at: "2012-05-22T08:13:46Z", id: 1, is_master: true, price: 123, product_id: 1, quantity: 200, sku: 123, updated_at: "2012-05-22T08:13:46Z"}}]})
      @showview.collection = new Backbone.Collection([
        @backboneModel1
      ]) 
      @showview.render

