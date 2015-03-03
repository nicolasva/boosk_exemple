describe 'App.Views.Orders.Show', ->
  beforeEach ->
    App.Views.Orders.Show.prototype.template = JST['app/assets/javascripts/backend/templates/orders/show']

    $("<div id='app'></div>").appendTo("body")

    @order = new Backbone.Model
      number: "abcedf-123-456-789"
      workflow_state: "shipped"
      line_items: [
        {
          quantity: 1
          product_variant:
            sku: ""
            price: 1
            product:
              uuid: ""
              name: ""
              tax_rate:
                label: ""
        }
      ]
      total: 0
      contact:
        lastname: ""
        firstname: ""
        phone: ""
        addresses: [
          {
            addr: ""
            zip_code: ""
            city: ""
            country: ""
            state: ""
          }
        ]
        emails: [
          {
            email: ""
          }
        ]
    @translate = new Backbone.Model
      back: ""
      views:
        order:
          status:
            paid:
              action: "paid"
              display: ""
            shipped:
              action: "shipped"
              display: ""
            delivered:
              action: "delivered"
              display: ""
            closed:
              action: "closed"
              display: ""
            canceled:
              action: "canceled"
              display: ""
          show:
            h2:
              details: ""
              ref: ""
            shipping_address: ""
          pu_ht: ""
          total_ht: ""
          total_ttc: ""
          shipping: ""
      activerecord:
        attributes:
          product:
            name: ""
          product_variant:
            sku: ""
            quantity: ""

    @view = new App.Views.Orders.Show
      order: @order
      translate: @translate

  afterEach ->
    $("#app").remove()

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'should create a DIV element', ->
      expect(@view.el.id).toEqual("app")

    it "renders immediately", ->
      @view.initialize
        order: @order
        translate: @translate
      expect(@renderStub).toHaveBeenCalledOnce()

  describe 'rendering', ->
    beforeEach ->
      sinon.spy(Haml, 'render')
      sinon.spy(@view, 'template')
      @view.render()

    afterEach ->
      Haml.render.restore()
      @view.template.restore()

    it 'returns the view object', ->
      expect(@view.render()).toEqual(@view)

    it 'calls template method', ->
      expect(@view.template).toHaveBeenCalledOnce()
      expect(@view.template).toHaveBeenCalledWithExactly()

    it 'calls Haml render method', ->
      expect(Haml.render).toHaveBeenCalledOnce()

  describe 'events', ->
    it 'handles correct events', ->
      expect(@view.events).toEqual
        "change select[name='action']": "change_status"

    describe 'when new status is selected', ->
      beforeEach ->
        @changeOrderStatusStub = sinon.stub(@order, "change_status")
        $("select[name='action']").change()

      afterEach ->
        @changeOrderStatusStub.restore()

      it 'saves new order status', ->
        expect(@changeOrderStatusStub).toHaveBeenCalledOnce()