describe "update_total_price_all_product_to_table view cartItems mobile", ->
  beforeEach ->
    @viewsCartUpdateTotalPriceAllProductToTable = new App.Views.Cart.UpdateTotalPriceAllProductToTable()

  describe "instantiation", ->
    beforeEach ->
      @renderStub = sinon.stub(@viewsCartUpdateTotalPriceAllProductToTable, 'render')

    afterEach ->
      @renderStub.restore()

    it "binds on '#value_total' element", ->
      expect(@viewsCartUpdateTotalPriceAllProductToTable.$el.selector).toEqual("#value_total")

    it "renders immediately", ->
      @viewsCartUpdateTotalPriceAllProductToTable.initialize()
      expect(@renderStub).toHaveBeenCalledOnce()
