describe "App.Views.ShippingMethods.Edit", ->
  beforeEach ->
    App.Views.ShippingMethods.Edit.prototype.template = JST['app/assets/javascripts/backend/templates/shipping/methods/edit']
    @translate = new Backbone.Model
      views:
        zone:
          add_zone: ""
        shipping_method:
          edit_shipping_method: ""
    @method = new Backbone.Model()
    @zones = new Backbone.Collection(model: Backbone.Model)
    @geographic_regions = new Backbone.Collection()
    @zonesCollectionStub = sinon.stub(App.Collections, 'Zones').returns(@zones)
    @geographicRegionsStub = sinon.stub(App.Collections, 'GeographicRegions').returns(@geographic_regions)

    @shippingMethodFormStub = sinon.stub(App.Views.ShippingMethods, 'Form').returns(new Backbone.View())
    @zoneFormStub = sinon.stub(App.Views.Zones, 'Form').returns(new Backbone.View())

    @fetchGeographicRegionsStub = sinon.stub(@geographic_regions, 'fetch').yieldsTo('success', @geographic_regions)

    @view = new App.Views.ShippingMethods.Edit
      translate : @translate.toJSON()
      model: @method

  afterEach ->
    @zonesCollectionStub.restore()
    @geographicRegionsStub.restore()
    @shippingMethodFormStub.restore()
    @zoneFormStub.restore()
    @fetchGeographicRegionsStub.restore()

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'should create a DIV element', ->
      expect(@view.el.tagName).toEqual("DIV")

    it "renders immediately", ->
      @view.initialize(translate: @translate)
      expect(@renderStub).toHaveBeenCalledOnce()

    it "should create zones collection", ->
      expect(@zonesCollectionStub).toHaveBeenCalledOnce()

    it "should create shipping methods collection", ->
      expect(@geographicRegionsStub).toHaveBeenCalledOnce()

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

    it 'should create a shipping method form view', ->
      expect(@shippingMethodFormStub).toHaveBeenCalledTwice()

    it 'should create a zone form view', ->
      expect(@zoneFormStub).toHaveBeenCalledTwice()

  describe 'events', ->
    beforeEach ->
      $(@view.el).appendTo("body")

    afterEach ->
      $(@view.el).remove()

    it 'should handle correct UI events', ->
      expect(@view.events).toEqual
        "submit #edit_shipping_method_form": "update"
        "click #add_zone": "showZoneForm"
        "submit #new_zone_form": "saveZone"
        "click #new_zone_form .back" : "showShippingMethodForm"

    describe 'when shipping method form is submitted', ->
      beforeEach ->
        @saveMethodStub = sinon.stub(@method, 'save')
        $("#edit_shipping_method_form").submit()

      afterEach ->
        @saveMethodStub.restore()

      it 'should update current model', ->
        expect(@saveMethodStub).toHaveBeenCalledOnce()

    describe "when 'add_zone' button is clicked", ->
      # TODO : these specs should be OK, but cannot be played because of a weird issue
      # beforeEach ->
      #   @clock = sinon.useFakeTimers()
      #   $("<button id='add_zone'></button>").appendTo("#edit_shipping_method_form")
      #   $("#edit_shipping_method_form").show()
      #   $("#new_zone_form").hide()
      #   $("#add_zone").click()
      #   @clock.tick(500)

      # afterEach ->
      #   @clock.restore()

      # it 'should hide shipping method form', ->
      #   expect($("#edit_shipping_method_form")).toBeHidden()

      # it 'should show zone form', ->
      #   expect($("#new_zone_form")).toBeVisible()

    describe "when zone form is submitted", ->
      beforeEach ->
        @createZonesStub = sinon.stub(@zones, 'create')
        $("#new_zone_form").submit()

      afterEach ->
        @createZonesStub.restore()

      it 'should create a zone', ->
        expect(@createZonesStub).toHaveBeenCalledOnce()

    describe "when 'back' button is clicked", ->
      beforeEach ->
        @clock = sinon.useFakeTimers()
        $("<button class='back'></button>").appendTo("#new_zone_form")
        $("#edit_shipping_method_form").hide()
        $("#new_zone_form").show()
        $("#new_zone_form .back").click()
        @clock.tick(500)

      afterEach ->
        @clock.restore()

      it 'should hide zone form', ->
        expect($("#new_zone_form")).toBeHidden()

      it 'should show shipping method form', ->
        expect($("#edit_shipping_method_form")).toBeVisible()