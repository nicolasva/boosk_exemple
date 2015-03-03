describe 'App.Views.ShopSettings.FacebookTabManagement', ->
  beforeEach ->
    App.Views.ShopSettings.FacebookTabManagement.prototype.template = JST['app/assets/javascripts/backend/templates/shop_settings/facebook_tab_management']

    @shop = new Backbone.Model(fan_page_id: "123456")
    @translate = new Backbone.Model
      views:
        shop:
          edit:
            add_to_page: ""
            no_fan_page: ""
        status:
          edit:
            help_block_facebook_select_fan_page: ""
      activerecord:
        attributes:
          shop:
            fan_page_id: ""

    @account = new Backbone.Model()
    @accountStub = sinon.stub(App, 'account').returns(@account)
    @customTabManagementViewStub = sinon.stub(App.Views.ShopSettings, 'CustomTabManagement').returns(new Backbone.View())
    @view = new App.Views.ShopSettings.FacebookTabManagement(shop: @shop, translate: @translate.toJSON())
    $(@view.el).appendTo("body")

  afterEach ->
    @customTabManagementViewStub.restore()
    $(@view.el).remove()
    @accountStub.restore()

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'should create a DIV element', ->
      expect(@view.el.tagName).toEqual("DIV")

    it "renders immediately", ->
      @view.initialize(shop: @shop, translate: @translate.toJSON())
      expect(@renderStub).toHaveBeenCalledOnce()

  describe 'rendering', ->
    beforeEach ->
      sinon.spy(Haml, 'render')
      sinon.spy(@view, 'template')

    afterEach ->
      Haml.render.restore()
      @view.template.restore()

    it 'returns the view object', ->
      expect(@view.render()).toEqual(@view)

    it 'calls template method', ->
      @view.render()
      expect(@view.template).toHaveBeenCalledOnce()
      expect(@view.template).toHaveBeenCalledWithExactly()

    it 'calls Haml render method', ->
      @view.render()
      expect(Haml.render).toHaveBeenCalledOnce()

    describe 'when no fan page has been fetched', ->
      beforeEach ->
        @view.fan_pages = []
        @view.render()

      it "shows a 'add to fan page' button", ->
        expect($('#add-to-fan-page')).toExist()

      it "does not show a fan page selector", ->
        expect($('select#fan_page_id')).not.toExist()

      it "does not create a custom tab management view", ->
        expect(@customTabManagementViewStub).not.toHaveBeenCalled()

    describe 'when fan pages have been fetched', ->
      beforeEach ->
        @shop.set(fan_page_id: '2')
        @view.fan_pages = [{id: '1', name: 'Page 1'}, {id: '2', name: 'Page 2'}]
        @view.render()

      it "does not show a 'add to fan page' button", ->
        expect($('#add-to-fan-page')).not.toExist()

      it "shows a fan page selector", ->
        expect($('select#fan_page_id')).toExist()

      it "creates a custom tab management view", ->
        expect(@customTabManagementViewStub).toHaveBeenCalledOnce()

      it "presets fan page selector with shop fan page ID value", ->
        expect($('#fan_page_id').val()).toEqual('2')

  describe 'events', ->
    it 'handle correct UI events', ->
      expect(@view.events).toEqual
        "click #add-to-fan-page": "logFBUserAndFetchInformation"
        "change #fan_page_id": "changeFanPageID"

    describe "when 'add to fan page' button is clicked", ->    
      beforeEach ->
        window.FB =
          login: sinon.stub().yields({authResponse: "123456"})
          getLoginStatus: sinon.stub()
          api: sinon.stub()
        sinon.stub(@account, 'save').yieldsTo('success', @account)
        @renderStub = sinon.stub(@view, 'render')

      afterEach ->
        @renderStub.restore()

      it 'logs current user', ->
        $("#add-to-fan-page").click()
        expect(FB.login).toHaveBeenCalledOnce()

      it 'checks login status', ->
        $("#add-to-fan-page").click()
        expect(FB.getLoginStatus).toHaveBeenCalledOnce()

      describe 'and FB user is connected', ->
        beforeEach ->
          FB.getLoginStatus.yields({status: 'connected'})

        it 'fetches FB user permissions', ->
          $('#add-to-fan-page').click()
          expect(FB.api).toHaveBeenCalledOnce()
          expect(FB.api).toHaveBeenCalledWith('/me/permissions')

        describe 'and user has allowed our app to manage his pages', ->
          beforeEach ->
            FB.api.withArgs('/me/permissions').yields(data: [{manage_pages: 1}])
            FB.api.withArgs('/me/accounts').yields(data: [])

          it 'fetches user pages', ->
            $('#add-to-fan-page').click()
            expect(FB.api).toHaveBeenCalledTwice()
            expect(FB.api).toHaveBeenCalledWith('/me/accounts')

          it 'renders view', ->
            $('#add-to-fan-page').click()
            expect(@renderStub).toHaveBeenCalledOnce()

        describe 'and user does not allow our app to manage his pages', ->
          beforeEach ->
            FB.api.withArgs('/me/permissions').yields(data: [{}])
            FB.api.withArgs('/me/accounts').yields(data: [])

          it 'does not fetches user pages', ->
            $('#add-to-fan-page').click()
            expect(FB.api).toHaveBeenCalledOnce()
            expect(FB.api).not.toHaveBeenCalledWith('/me/accounts')

          it 'does not render the view', ->
            $('#add-to-fan-page').click()
            expect(@renderStub).not.toHaveBeenCalled()

      describe 'and FB user is not connected', ->
        beforeEach ->
          FB.getLoginStatus.yields({status: 'not_connected'})

        it 'does not fetch FB user permissions', ->
          $('#add-to-fan-page').click()
          expect(FB.api).not.toHaveBeenCalled()

        it 'does not render the view', ->
          $('#add-to-fan-page').click()
          expect(@renderStub).not.toHaveBeenCalled()

    describe 'when fan page ID selected value changes', ->
      it 'updates shop model', ->
        @shop.set(fan_page_id: '1')
        @view.fan_pages = [{id: '1', name: 'Page 1'}, {id: '2', name: 'Page 2'}]
        @view.render()
        $('#fan_page_id').val('2').change()
        expect(@shop.get('fan_page_id')).toEqual('2')
