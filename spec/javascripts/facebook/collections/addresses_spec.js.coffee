describe "Addresses collections facebook", ->
  beforeEach ->
    @country_id = 1
    @state_id = 1 
    @namespace_facebook = "/"+App.ui()+"/"
    @url_country = "country/"
    @url_states = "/states/"
    @url_address = "/addresses"
    @addresses_url = "#{@namespace_facebook}#{@url_country}#{@country_id}#{@url_states}#{@state_id}#{@url_address}"
    @addresses = new App.Collections.Addresses()
    @addresse1_fixture = 
     "city":"PANTIN"
     "country_id": @country_id
     "designation":"test_nicolas1"
     "firstname":"Nicolas"
     "id":1
     "lastname":"VANDENBOGAERDE"
     "state_id": @state_id
     "user_id":1
     "zip_code":"93500"
     "country": 
       "id":1
       "name":"dfdsfsdf"
    @addresse2_fixture = 
      "city": "PARIS"
      "country_id": @country_id
      "designation":"test_nicolas2"
      "firstname":"Nicolas_test"
      "id":2
      "lastname":"VANDENBOGAERDE2"
      "state_id": @state_id
      "user_id":2
      "zip_code":"75003"
      "country":
        "id":2
        "name":"retestnicolas"
    @addresse3_fixture = 
      "city": "CLERMONT"
      "country_id": @country_id 
      "designation":"test_nicolas3"
      "firstname":"Nicolas_test"
      "id":3
      "lastname":"VANDENBOGAERDE3"
      "state_id": @state_id
      "user_id":3
      "zip_code":"75010"
      "country":
        "id":3
        "name":"retestnicolas"

  it "should be defined", ->
    expect(@addresses).toBeDefined()

  it "should return the address url", ->
    addresses = @addresses 
    addresses.url = @addresses_url
    expect(addresses.url).toEqual(@addresses_url) 

  it "Can be instantiated", ->
    expect(@addresses).not.toBeNull()

  describe "#fetch", ->
    beforeEach ->
      @server = sinon.fakeServer.create()
  
    afterEach ->
      @server.restore()

