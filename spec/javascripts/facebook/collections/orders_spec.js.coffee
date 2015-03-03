describe "Orders Collection", ->
  beforeEach ->
    @order_id = 1
    @country_id = 1
    @state_id = 1
    @address_id = 1
    @facebook_namespace = "/"+App.ui()+"/"
    @url_country = "country/"
    @url_states = "states/"
    @url_addresses = "/addresses/"
    @url_orders = "/orders"
    @orders_url = "#{@facebook_namespace}#{@url_country}#{@country_id}#{@url_states}#{@state_id}#{@url_addresses}#{@address_id}#{@url_orders}"
    @orders = new App.Collections.Orders()
    @order1_fixture = 
      "address_id":@address_id,
      "credit_total":"123.0"
      "email":"nicolas.vandenbogaerde@gmail.com"
      "id":@order_id
      "item_total":"1.0"
      "number":"123"
      "order_id":@order_id
      "paid":false
      "payment_state":"fr"
      "payment_total":"123.0"
      "shop_id":1
      "special_instructions": "special_instruction_1"
      "state_id": @state_id
      "total":"1234.0"
      "line_items":[{
        "id":1
        "order_id":@order_id
        "price":"123.0"
        "product_variant_id":1
        "quantity":123,
        "product_variant":
          "created_at":"2012-05-22T08:13:46Z"
          "id":1
          "is_master":true
          "price":"123.0"
          "product_id":1
          "quantity":0
          "sku":"123"
          "updated_at":"2012-05-22T08:13:46Z"
          "product":
            "created_at":"2012-05-22T08:13:46Z"
            "description":"fdfdsfsdfdsfsd"
            "id":1
            "name":"test"
            "permalink":"http://google.fr"
            "shop_id":1
            "status":0
            "updated_at":"2012-05-22T08:13:46Z"
            "uuid":"ecaa08c1-3558-115e-7457-0fde89732bdb"
      }]

    @order2_fixture =  
      "address_id":@address_id,
      "credit_total":"256.0"
      "email":"nicolas.vandenbogaerde@gmail.com"
      "id":2
      "item_total":"2.0"
      "number":"500"
      "order_id":@order_id
      "paid":false
      "payment_state":"fr"
      "payment_total":"360.0"
      "shop_id":1
      "special_instructions": "special_instruction_1"
      "state_id": @state_id
      "total":"1234.0"
      "line_items":[{
        "id":1
        "order_id":@order_id
        "price":"250.0"
        "product_variant_id":1
        "quantity":250,
        "product_variant":
          "created_at":"2012-05-22T08:13:46Z"
          "id":1
          "is_master":true
          "price":"400.0"
          "product_id":1
          "quantity":0
          "sku":"1200"
          "updated_at":"2012-05-22T08:13:46Z"
          "product":
            "created_at":"2012-05-22T08:13:46Z"
            "description":"fdfdsfsdfdsfsd"
            "id":1
            "name":"test"
            "permalink":"http://google.fr"
            "shop_id":1
            "status":0
            "updated_at":"2012-05-22T08:13:46Z"
            "uuid":"ecaa08c1-3558-115e-7457-0fde89732bdb"
      }]
    @order3_fixture =  
      "address_id":@address_id,
      "credit_total":"256.0"
      "email":"nicolas.vandenbogaerde@gmail.com"
      "id":2
      "item_total":"2.0"
      "number":"500"
      "order_id":@order_id
      "paid":false
      "payment_state":"fr"
      "payment_total":"360.0"
      "shop_id":1
      "special_instructions": "special_instruction_1"
      "state_id": @state_id
      "total":"1234.0"
      "line_items":[{
        "id":1
        "order_id":@order_id
        "price":"250.0"
        "product_variant_id":1
        "quantity":250,
        "product_variant":
          "created_at":"2012-05-22T08:13:46Z"
          "id":1
          "is_master":true
          "price":"400.0"
          "product_id":1
          "quantity":0
          "sku":"1200"
          "updated_at":"2012-05-22T08:13:46Z"
          "product":
            "created_at":"2012-05-22T08:13:46Z"
            "description":"fdfdsfsdfdsfsd"
            "id":1
            "name":"test"
            "permalink":"http://google.fr"
            "shop_id":1
            "status":0
            "updated_at":"2012-05-22T08:13:46Z"
            "uuid":"ecaa08c1-3558-115e-7457-0fde89732bdb"
      }]

  it "should be defined", ->
    expect(@orders).toBeDefined()

  it "should return the order url", ->
    orders = @orders
    orders.url = @orders_url
    expect(orders.url).toEqual(@orders_url)

  it "Can be instantiated", ->
    expect(@orders).not.toBeNull()

  describe '#fetch', ->
    beforeEach ->
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

