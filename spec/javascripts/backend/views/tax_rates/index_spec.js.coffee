describe 'App.Views.TaxRates.Index', ->
  beforeEach ->
    App.Views.TaxRates.Index.prototype.template = JST['app/assets/javascripts/backend/templates/tax_rates/index']
    App.Views.TaxRates.Index.prototype.store_settings_menu = JST['app/assets/javascripts/backend/templates/shared/store_settings_menu']
    App.Views.TaxRates.Index.prototype.support_block = JST['app/assets/javascripts/backend/templates/shared/support_block']

    @translate = new Backbone.Model
      delete: ""
      add: ""
      actions: ""
      back: ""
      next: ""

      views:
        tax_rate:
          index:
            h2: ""
          you_have_not_yet_tax_rates: ""
          add_tax: ""
          no_tax_selected_warning: ""
      activerecord:
        attributes:
          tax_rate:
            label: ""
            rate: ""
            zone_ids: ""


    @zones = new Backbone.Collection()
    @tax_rates = new Backbone.Collection()
    @shop = new Backbone.Model()

    @view = new App.Views.TaxRates.Index(collection: @tax_rates, zones: @zones, shop: @shop, translate: @translate, wizard: false)
    setFixtures(sandbox(id: "app"))
    $(@view.el).appendTo("#app")

  describe 'instantiation', ->
    beforeEach ->
      @renderStub = sinon.stub(@view, 'render')

    afterEach ->
      @renderStub.restore()

    it 'should create a SECTION element with "store-settings" ID and "container-fluid" class', ->
      expect($(@view.el)).toBe("section#store-settings.container-fluid")

    it 'does not render immediately', ->
      @view.initialize(collection: @tax_rates, zones: @zones, shop: @shop, translate: @translate, wizard: false)
      expect(@renderStub).not.toHaveBeenCalled()

  describe 'rendering', ->
    beforeEach ->
      sinon.spy(Haml, 'render')
      sinon.spy(@view, 'template')
      sinon.spy(@view, 'store_settings_menu')
      sinon.spy(@view, 'support_block')
      @rowTableStub = sinon.stub(App.Views.TaxRates, 'RowTable').returns(new Backbone.View())

    afterEach ->
      Haml.render.restore()
      @view.template.restore()
      @view.store_settings_menu.restore()
      @view.support_block.restore()
      @rowTableStub.restore()

    it 'returns the view object', ->
      expect(@view.render()).toEqual(@view)

    it 'calls template method', ->
      @view.render()
      expect(@view.template).toHaveBeenCalledOnce()
      expect(@view.template).toHaveBeenCalledWithExactly()

    it 'calls store settings menu template', ->
      @view.render()
      expect(@view.store_settings_menu).toHaveBeenCalledOnce()

    it 'calls support block template', ->
      @view.render()
      expect(@view.support_block).toHaveBeenCalledOnce()

    it 'calls Haml render method', ->
      @view.render()
      expect(Haml.render).toHaveBeenCalledThrice()

    describe 'when tax rates collection is empty', ->
      beforeEach ->
        @tax_rates.reset()

      it 'displays a "no item" message', ->
        @view.render()
        expect($(@view.el)).toContain(".no-items")
        expect($(@view.el).find(".no-items")).toBeVisible()

      it 'generates a tax rates table', ->
        @view.render()
        expect($(@view.el)).toContain("table")

      it 'does not create any row in the table', ->
        @view.render()
        expect(@rowTableStub).not.toHaveBeenCalled()

      it 'hides the tax rates table', ->
        @view.render()
        expect($(@view.el).find("table")).toBeHidden()

      it 'hides action buttons', ->
        @view.render()
        expect($(@view.el).find(".add")).toBeHidden()
        expect($(@view.el).find(".action-taxe")).toBeHidden()

    describe 'when tax rates collection has items', ->
      beforeEach ->
        @tax_rate1 = new Backbone.Model()
        @tax_rate2 = new Backbone.Model()
        @tax_rate3 = new Backbone.Model()
        @tax_rates.reset([@tax_rate1, @tax_rate2, @tax_rate3])

      it 'does not display "no item" message', ->
        @view.render()
        expect($(@view.el)).not.toContain(".no-items")

      it 'generates a tax rates table', ->
        @view.render()
        expect($(@view.el)).toContain("table")

      it 'create a row for each tax rate', ->
        @view.render()
        expect(@rowTableStub).toHaveBeenCalledThrice()

      it 'shows the tax rates table', ->
        @view.render()
        expect($(@view.el).find("table")).toBeVisible()

      it 'shows action buttons', ->
        @view.render()
        expect($(@view.el).find(".add")).toBeVisible()
        expect($(@view.el).find(".action-taxe")).toBeVisible()

    describe 'when user is in wizard mode', ->
      beforeEach ->
        @view.wizard = true

      it 'adds a "back" button', ->
        @view.render()
        expect($(@view.el).find(".wizard-actions")).toContain(".btn.back")

      it 'adds a "next" button', ->
        @view.render()
        expect($(@view.el).find(".wizard-actions")).toContain(".btn.next")

    describe 'when user is not in wizard mode', ->
      beforeEach ->
        @view.wizard = false

      it 'does not add any wizard actions buttons', ->
        @view.render()
        expect($(@view.el).find(".wizard-actions")).toBeEmpty()

  describe 'events', ->

    describe 'when a tax rate is added in collection', ->
      beforeEach ->
        @rowTableStub = sinon.stub(App.Views.TaxRates, 'RowTable').returns(new Backbone.View())
        @view.render()

      afterEach ->
        @rowTableStub.restore()

      it 'creates a new row table', ->
        @tax_rates.add(new Backbone.Model())
        expect(@rowTableStub).toHaveBeenCalledOnce()

    describe 'when "new tax rate" button is clicked', ->
      beforeEach -> 
        @view.render()
        @newTaxRateViewStub = sinon.stub(App.Views.TaxRates, 'New').returns(new Backbone.View())
        sinon.spy(jQuery.prototype, 'modal')

      afterEach ->
        @newTaxRateViewStub.restore()
        jQuery.prototype.modal.restore()

      it 'creates a tax rate creation view', ->
        $("#new_tax_rate").click()
        expect(@newTaxRateViewStub).toHaveBeenCalledOnce()

      it 'modalizes the view created', ->
        $("#new_tax_rate").click()
        expect(jQuery.prototype.modal).toHaveBeenCalledOnce()

    describe 'when "select all" checkbox is clicked', ->
      beforeEach ->
        @view.render()
        @tax_selected = $("<input type='checkbox' class='tax-selected' />")
        @tax_selected.appendTo(@view.el)

      describe 'and checkbox was unchecked', ->
        it 'checks all ".tax-selected" checkboxes', ->
          $(".select-all").prop("checked", true).click()
          expect(@tax_selected).toBeChecked()

      describe 'and checkbox was checked', ->
        it 'unchecks all ".tax-selected" checkboxes', ->
          $(".select-all").prop("checked", false).click()
          expect(@tax_selected).not.toBeChecked()

    describe 'when "destroy" action is selected in actions selector', ->
      beforeEach ->
        @popUpStub = sinon.stub(App.Views, 'Popup').returns(new Backbone.View())
        @bulkDestroyStub = sinon.stub(@tax_rates, 'bulk_destroy')
        @taxRatesSelectedStub = sinon.stub(@view, 'get_tax_rates_selected')
        sinon.spy(App.eventsDispatcher, 'trigger')
        @view.render()

      afterEach ->
        @popUpStub.restore()
        @bulkDestroyStub.restore()
        App.eventsDispatcher.trigger.restore()

      describe 'and no item has been selected', ->
        beforeEach ->
          @taxRatesSelectedStub.returns([])

        it 'displays a warning pop up', ->
          $('.action').val(0).change()
          expect(@popUpStub).toHaveBeenCalledOnce()

        it 'does not destroy any tax rate', ->
          $('.action').val(0).change()
          expect(@bulkDestroyStub).not.toHaveBeenCalled()

        it 'does not trigger any loading event', ->
          $('.action').val(0).change()
          expect(App.eventsDispatcher.trigger).not.toHaveBeenCalled()

      describe 'and some items have been selected', ->
        beforeEach ->
          @tax_rate1 = new Backbone.Model()
          @tax_rate2 = new Backbone.Model()
          @taxRatesSelectedStub.returns([@tax_rate1, @tax_rate2])

        it 'does not display any pop up', ->
          $('.action').val(0).change()
          expect(@popUpStub).not.toHaveBeenCalled()

        it 'destroys selected items', ->
          $('.action').val(0).change()
          expect(@bulkDestroyStub).toHaveBeenCalledOnce()

        it 'triggers "startLoading event"', ->
          $('.action').val(0).change()
          expect(App.eventsDispatcher.trigger).toHaveBeenCalledOnce()
          expect(App.eventsDispatcher.trigger).toHaveBeenCalledWith('startLoading')

        describe 'and destroy is successful', ->
          beforeEach ->
            @bulkDestroyStub.yieldsTo('success', [@tax_rate1, @tax_rate2])

          it 'triggers "loadingComplete" event', ->
            $('.action').val(0).change()
            expect(App.eventsDispatcher.trigger).toHaveBeenCalledTwice()
            expect(App.eventsDispatcher.trigger).toHaveBeenCalledWith('loadingComplete')

        describe 'and destroy fails', ->
          beforeEach ->
            @bulkDestroyStub.yieldsTo('error', [@tax_rate1, @tax_rate2])

          it 'triggers "loadingComplete" event', ->
            $('.action').val(0).change()
            expect(App.eventsDispatcher.trigger).toHaveBeenCalledTwice()
            expect(App.eventsDispatcher.trigger).toHaveBeenCalledWith('loadingComplete')
