describe "Orders collection", ->
  beforeEach ->
   #/shops/:shop_id/orders(.:format)  
   @address_id = 1
   App.current_shop = 1
   @orders_url = "/shops/#{App.current_shop}/orders"
   @orders = new App.Collections.Orders()
   @order1_fixture =
     "id":1
     "number":"123456789123456" 
     "item_total":123
     "total":245
     "state":"fr"
     "credit_total":123.5
     "payment_total":553.4
     "payment_state":"fr"
     "email":"nicolas.vandenbogaerde@gmail.com"
     "special_instructions":"special instructions test1"
     "paid": true
     "shop_id": App.current_shop
     "address_id": @address_id
   @order2_fixture =
     "id":2
     "number":"214356789123465" 
     "item_total":456
     "total":890
     "state":"fr"
     "credit_total":200.5
     "payment_total":999.4
     "payment_state":"fr"
     "email":"nicolastest.vandenbogaerde@gmail.com"
     "special_instructions":"special instructions test2"
     "paid": false
     "shop_id": App.current_shop
     "address_id": @address_id

  it "should be defined", ->
    expect(App.Collections.Orders).toBeDefined()

  it "should return the order url", ->
    expect(@orders.url()).toEqual(@orders_url)

  it "can be instantiated", ->
    expect(@orders).not.toBeNull()

  describe '#fetch', ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    describe 'request', ->
      beforeEach ->
        @request = @server.requests[0]

      it "fetch order", ->
        @orders.fetch() 

    describe "on success", ->
      beforeEach ->
        @response_orders_fixture = 
          "orders": [@order1_fixture, @order2_fixture]
        @server.respondWith(
          "GET",
          @order_url,
          [
            200,
            {"Content-type" : "application/json"},
            JSON.stringify(@response_orders_fixture) 
          ]
        )
        @orders.fetch()
        @server.respond() 

      describe "loaded tasks collection", ->
        it "loads all tasks", ->
          expect(@orders.toJSON()[0]["orders"].length).toEqual(2)

        describe "parses tasks form the responses", ->
          it "response for order1", ->
            expect(@orders.toJSON()[0]["orders"][0].id).toEqual(@order1_fixture.id)
            expect(@orders.toJSON()[0]["orders"][0].number).toEqual(@order1_fixture.number)
            expect(@orders.toJSON()[0]["orders"][0].item_total).toEqual(@order1_fixture.item_total)
            expect(@orders.toJSON()[0]["orders"][0].total).toEqual(@order1_fixture.total)
            expect(@orders.toJSON()[0]["orders"][0].state).toEqual(@order1_fixture.state)
            expect(@orders.toJSON()[0]["orders"][0].credit_total).toEqual(@order1_fixture.credit_total)
            expect(@orders.toJSON()[0]["orders"][0].payment_total).toEqual(@order1_fixture.payment_total) 
            expect(@orders.toJSON()[0]["orders"][0].payment_state).toEqual(@order1_fixture.payment_state)
            expect(@orders.toJSON()[0]["orders"][0].email).toEqual(@order1_fixture.email)
            expect(@orders.toJSON()[0]["orders"][0].special_instructions).toEqual(@order1_fixture.special_instructions)
            expect(@orders.toJSON()[0]["orders"][0].paid).toEqual(@order1_fixture.paid)
            expect(@orders.toJSON()[0]["orders"][0].shop_id).toEqual(@order1_fixture.shop_id)
            expect(@orders.toJSON()[0]["orders"][0].address_id).toEqual(@order1_fixture.address_id)

          it "response for order2", ->
            expect(@orders.toJSON()[0]["orders"][1].id).toEqual(@order2_fixture.id)
            expect(@orders.toJSON()[0]["orders"][1].number).toEqual(@order2_fixture.number)
            expect(@orders.toJSON()[0]["orders"][1].item_total).toEqual(@order2_fixture.item_total)
            expect(@orders.toJSON()[0]["orders"][1].total).toEqual(@order2_fixture.total)
            expect(@orders.toJSON()[0]["orders"][0].state).toEqual(@order1_fixture.state)
            expect(@orders.toJSON()[0]["orders"][0].credit_total).toEqual(@order1_fixture.credit_total)
            expect(@orders.toJSON()[0]["orders"][0].payment_total).toEqual(@order1_fixture.payment_total) 
            expect(@orders.toJSON()[0]["orders"][0].payment_state).toEqual(@order1_fixture.payment_state)
            expect(@orders.toJSON()[0]["orders"][0].email).toEqual(@order1_fixture.email)
            expect(@orders.toJSON()[0]["orders"][0].special_instructions).toEqual(@order1_fixture.special_instructions)
            expect(@orders.toJSON()[0]["orders"][0].paid).toEqual(@order1_fixture.paid)
            expect(@orders.toJSON()[0]["orders"][0].shop_id).toEqual(@order1_fixture.shop_id)
            expect(@orders.toJSON()[0]["orders"][0].address_id).toEqual(@order1_fixture.address_id)
