describe "Model Bsksession", ->
  beforeEach ->
    App.current_shop = 1
    @url_bsksession = "/bsksession"
    @bsksession_fixture = 
      "shop_id": App.current_shop
   

  it 'should be defined', ->
    expect(App.Bsksession).toBeDefined()

  it 'can be instantiated', ->
    bsksession = new App.Bsksession
    expect(bsksession).not.toBeNull()

  describe "check url", ->
    beforeEach ->
      @bsksession = new App.Bsksession

    it "should return the URL", ->
      expect(@bsksession.url()).toEqual(@url_bsksession)


  describe "bsksession save and fetch", ->
    beforeEach ->
      @server = sinon.fakeServer.create()
      @bsksession = new App.Bsksession(@bsksession_fixture)
      @server.respondWith(
        "POST"
        @url_bsksession,
        [
          200,
          {"Content-Type" : "application/json"},
          @bsksession_fixture.toString()
        ]
      ) 
      @eventSpy = sinon.spy()
      @bsksession.save()

    afterEach ->
      @server.restore()

    it "should request method POST ?", ->
      expect(@server.requests[0].method).toEqual("POST")
   
    it "should request url /bsksession ?", ->
      expect(@server.requests[0].url).toEqual(@url_bsksession)

    it "should request requestBody to equal with bsksession_attributes ?", ->
      expect(JSON.parse(@server.requests[0].requestBody)).toEqual(@bsksession.attributes)
