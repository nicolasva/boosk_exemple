require 'spec_helper'

describe OrdersController do
  before(:each) do
    @user = create(:user, :plan_id => create(:plan))
    @shop = create(:shop, :users => [@user])
    sign_in @user
  end
 
  describe "#index" do
    before(:each) do
      @order = create(:order, :shop_id => @shop.id)
      Order.any_instance.stub(:pay).and_return(true)
    end

    it "orders should be have paid status at least" do
      @order.pay!
      get :index, :shop_id => @shop.uuid
      assigns(:orders).should_not be_empty
      assigns(:orders).should include(@order)

      response.should be_success 
    end

    it "orders should not be have unpaid status" do
      get :index, :shop_id => @shop.uuid
      assigns(:orders).should be_empty
      assigns(:orders).should_not include(@order)

      response.should be_success 
    end
  end

  describe "#show" do
    before(:each) do
      @order= create(:order, :shop_id => @shop.id)
      Order.any_instance.stub(:pay).and_return(true)
    end

    it "order should be have paid status at least" do
      @order.pay!
      get :show, :shop_id => @order.shop.uuid, :id => @order.number, :format => :json
      assigns(:order).should_not be_nil
      assigns(:order).should eq(@order)

      response.should be_success
    end

  end 
end

