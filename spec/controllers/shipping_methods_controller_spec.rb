require 'spec_helper'

describe ShippingMethodsController do
  before(:each) do
    @user = create(:user, :plan_id => create(:plan))
    @shop = create(:shop, :users => [@user])
    sign_in @user
  end

  describe "#index" do 
    context "when there isn't any shipping category created" do
      it "access index page" do
        get :index, :shop_id => @shop.uuid
        response.should be_success
      end

      it "assigns @shipping_methods to an empty array" do
        get :index, :shop_id => @shop.uuid
        assigns(:shipping_methods).should == []
      end
    end

    context "when there are some shipping categories created" do
      before do
        @shipping_methods = [create(:shipping_method, :shop => @shop), create(:shipping_method, :shop => @shop)]
        @shop.stub :shipping_methods, @shipping_methods
      end

      it "access index page" do
        get :index, :shop_id => @shop.uuid
        response.should be_success
      end

      it "assigns @shipping_methods to @shop.shipping_methods" do
        get :index, :shop_id => @shop.uuid
        assigns(:shipping_methods).should == @shipping_methods
      end
    end
  end

  describe "#show" do
    before { @shipping_method = create(:shipping_method, :shop_id => @shop.id) }

    it "access page show" do
      get :show, :id => @shipping_method.id, :shop_id => @shop.uuid
      response.should be_success
    end

    it "assigns @shipping_method" do
      get :show, :id => @shipping_method.id, :shop_id => @shop.uuid
      assigns(:shipping_method).should == @shipping_method
    end
  end 

  describe "#new and #create" do
    before(:each) do
      @zone = create(:zone, :shop => @shop)
      @shipping_method = build(:shipping_method, :shop_id => @shop.id, :zone => @zone)
      ShippingMethod.stub!(:build).and_return(@shipping_method)
    end

    it "access page new" do
      get :new, :shop_id => @shop.uuid
      response.should be_success 
    end

    it "assigns @shipping_method" do
      get :new, :shop_id => @shop.uuid
      assigns(:shipping_method).should be    
    end

    it "access to create" do
      @params = {:shipping_method => {:name => @shipping_method.name, :calculator_type => @shipping_method.calculator_type, :zone_id => @zone.id}, :shop_id => @shop.uuid}
      lambda {
        post :create, @params
      }.should change(ShippingMethod, :count).by(1) 
    end

    it "redirects after shipping method creation" do
      @params = {:shipping_method => {:name => @shipping_method.name, :calculator_type => @shipping_method.calculator_type, :zone_id => @zone.id}, :shop_id => @shop.uuid}
      post :create, @params
      response.should redirect_to shop_shipping_methods_path(@shop)
    end

    it "sets flash notice after shipping method creation" do
      @params = {:shipping_method => {:name => @shipping_method.name, :calculator_type => @shipping_method.calculator_type, :zone_id => @zone.id}, :shop_id => @shop.uuid}
      post :create, @params
      flash[:notice].should be
    end
  end

  describe "#edit and update" do
    before(:each) do
      @shipping_method = create(:shipping_method, :shop_id => @shop.id)
    end

    it "edit" do
      get :edit, :id => @shipping_method.id, :shop_id => @shop.uuid
      response.should be_success
    end

    it "assigns @shipping_method" do
      get :edit, :id => @shipping_method.id, :shop_id => @shop.uuid
      assigns(:shipping_method).should == @shipping_method
    end

    it "does not change shipping methods count" do
      @params = {:id => @shipping_method.id, :shop_id => @shop.uuid, :shipping_method => {:name => "#{@shipping_method.name}test", :calculator_type => @shipping_method.calculator_type} }
      lambda {
        put :update, @params
      }.should_not change(ShippingMethod, :count)
    end

    it "redirects after shipping method edition" do
      @params = {:id => @shipping_method.id, :shop_id => @shop.uuid, :shipping_method => {:name => "#{@shipping_method.name}test", :calculator_type => @shipping_method.calculator_type} }
      put :update, @params
      response.should redirect_to shop_shipping_methods_path(@shop)
    end

    it "sets flash notice after shipping method edition" do
      @params = {:id => @shipping_method.id, :shop_id => @shop.uuid, :shipping_method => {:name => "#{@shipping_method.name}test", :calculator_type => @shipping_method.calculator_type} }
      put :update, @params
      flash[:notice].should be
    end

  end
  
  describe "#destroy" do
    before { @shipping_method = create(:shipping_method, :shop_id => @shop.id) }
    it { expect { delete :destroy, :format => "js", :id => @shipping_method.id, :shop_id => @shop.uuid }.to change{ ShippingMethod.count }.by(-1) }
  end

end
