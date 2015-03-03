describe 'App.Views.Plans.Index', ->
  beforeEach ->
    App.Views.Plans.Index.prototype.template = JST['app/assets/javascripts/backend/templates/plans/index']

    $("<div id='app'></div>").appendTo("body")

    @translate = new Backbone.Model
      month: ""
      or: ""
      year: ""
      go: ""
      unlimited: ""
      daily: ""
      custom: ""
      views:
        plan:
          h3_free_trial: ""
          p_free_trial: ""
          h3_payment_methods: ""
          p_payment_methods: ""
          prices_and_services: ""
          admins: ""
          f_shops: ""
          m_shops: ""
          social_sharing: ""
          feature_product: ""
          google_shopping: ""
          import_product_xml_csv: ""
          customization_and_templates: ""
          illimited_products: ""
          social_and_sales_analytics: ""
          full_api_customization: ""
          auto_update_from_xml_and_csv: ""
          support: ""
          help:
            admins: ""
            f_shops: ""
            m_shops: ""
            social_sharing: ""
            feature_product: ""
            google_shopping: ""
            import_product_xml_csv: ""
            customization_and_templates: ""
            illimited_products: ""
            social_and_sales_analytics: ""
            full_api_customization: ""
            auto_update_from_xml_and_csv: ""
            support: ""

    @account = new Backbone.Model
      plan_id: 1
    @plan1 = new Backbone.Model
      id: 1
      name: "plan1"
      monthly_price: 0
      yearly_price: 0
      number_admin: 0
      number_f_shop: 0
      number_m_shop: 0
      has_social: true
      has_deals: true
      has_google_shopping: true
      has_data_import: true
      has_customization: true
      has_analytics: true
      has_api_access: true
      has_auto_data_import: 0
    @plan2 = new Backbone.Model
      id: 2
      name: "plan2"
      number_admin: 0
      monthly_price: 10
      yearly_price: 0
      number_f_shop: 0
      number_m_shop: 0
      has_social: true
      has_deals: true
      has_google_shopping: true
      has_data_import: true
      has_customization: true
      has_analytics: true
      has_api_access: true
      has_auto_data_import: 0
    @plans = new Backbone.Collection([@plan1, @plan2])

    @view = new App.Views.Plans.Index(translate: @translate, account: @account, plans: @plans)

  afterEach ->
    $("#app").remove()

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'binds on #app element', ->
      expect(@view.$el.selector).toEqual("#app")

    it "renders immediately", ->
      @view.initialize(translate: @translate, account: @account, plans: @plans)
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
    it 'should handle correct events', ->
      expect(@view.events).toEqual
        "click .choose": "choose_plan"

    describe "when a plan is selected", ->
      beforeEach ->
        @choosePeriodViewStub = sinon.stub(App.Views.Plans, 'ChoosePeriod').returns(new Backbone.View())
        $(".plan2 .header .choose").click()

      afterEach ->
        @choosePeriodViewStub.restore()

      it "should display a pop up with the subscription period", ->
        expect(@choosePeriodViewStub).toHaveBeenCalledOnce()
