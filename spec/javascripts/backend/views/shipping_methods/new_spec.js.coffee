describe "App.Views.ShippingMethods.New", ->
  beforeEach ->
    App.Views.ShippingMethods.New.prototype.template = JST['app/assets/javascripts/backend/templates/shipping/methods/new']
    @translate = new Backbone.Model
      views:
        zone:
          add_zone: ""
        shipping_method:
          add_shipping_method: ""
    @methods = new Backbone.Collection
    @methods.model = Backbone.Model
    @zones = new Backbone.Collection()
    @zonesCollectionStub = sinon.stub(App.Collections, 'Zones').returns(@zones)
    @geographicRegions = new Backbone.Collection()
    @geographicRegionsStub = sinon.stub(App.Collections, 'GeographicRegions').returns(@geographicRegions)
    @fetchGeographicRegionsStub = sinon.stub(@geographicRegions, 'fetch').yieldsTo('success', @geographicRegions)

    @methodFormStub = sinon.stub(App.Views.ShippingMethods, 'Form').returns(new Backbone.View())
    @zoneFormStub = sinon.stub(App.Views.Zones, 'Form').returns(new Backbone.View())

    @view = new App.Views.ShippingMethods.New(collection: @methods, translate: @translate.toJSON())

  afterEach ->
    @zonesCollectionStub.restore()
    @geographicRegionsStub.restore()
    @fetchGeographicRegionsStub.restore()
    @methodFormStub.restore()
    @zoneFormStub.restore()

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'should create a DIV element', ->
      expect(@view.el.tagName).toEqual("DIV")

    it "renders immediately", ->
      @view.initialize(collection: @methods, translate: @translate.toJSON())
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
      expect(@methodFormStub).toHaveBeenCalledTwice()

    it 'should create a zone form view', ->
      expect(@zoneFormStub).toHaveBeenCalledTwice()

  describe 'events', ->
    beforeEach ->
      $(@view.el).appendTo("body")

    afterEach ->
      $(@view.el).remove()

    it 'should handle correct UI events', ->
      expect(@view.events).toEqual
        "submit #new_shipping_method_form": "save"
        "click #add_zone": "showZoneForm"
        "submit #new_zone_form": "saveZone"
        "click #new_zone_form .back" : "showShippingMethodForm"

    describe 'when shipping method form is submitted', ->
      beforeEach ->
        @createMethodsStub = sinon.stub(@methods, 'create')
        $("#new_shipping_method_form").submit()

      afterEach ->
        @createMethodsStub.restore()

      it 'should create a new method in the methods collection', ->
        expect(@createMethodsStub).toHaveBeenCalledOnce()

    describe "when 'add_zone' button is clicked", ->
      # TODO : these specs should be OK, but cannot be played because of a weird issue
      # beforeEach ->
      #   @clock = sinon.useFakeTimers()
      #   $("<button id='add_zone'></button>").appendTo("#new_shipping_method_form")
      #   $("#new_shipping_method_form").show()
      #   $("#new_zone_form").hide()
      #   $("#add_zone").click()
      #   @clock.tick(500)

      # afterEach ->
      #   @clock.restore()

      # it 'should hide shipping method form', ->
      #   expect($("#new_shipping_method_form")).toBeHidden()

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
        $("#new_shipping_method_form").hide()
        $("#new_zone_form").show()
        $("#new_zone_form .back").click()
        @clock.tick(500)

      afterEach ->
        @clock.restore()

      it 'should hide zone form', ->
        expect($("#new_zone_form")).toBeHidden()

      it 'should show shipping method form', ->
        expect($("#new_shipping_method_form")).toBeVisible()