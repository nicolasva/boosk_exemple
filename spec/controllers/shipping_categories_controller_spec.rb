require 'spec_helper'

describe ShippingCategoriesController do
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

      it "assigns @shipping_categories to an empty array" do
        get :index, :shop_id => @shop.uuid
        assigns(:shipping_categories).should == []
      end
    end

    context "when there are some shipping categories created" do
      before do
        @shipping_categories = [create(:shipping_category, :shop => @shop), create(:shipping_category, :shop => @shop)]
        @shop.stub :shipping_categories, @shipping_categories
      end

      it "access index page" do
        get :index, :shop_id => @shop.uuid
        response.should be_success
      end

      it "assigns @shipping_categories to @shop.shipping_categories" do
        get :index, :shop_id => @shop.uuid
        assigns(:shipping_categories).should == @shipping_categories
      end
    end
  end

  describe "#show" do
    before { @shipping_category = create(:shipping_category, :shop_id => @shop.id) }

    it "access page show" do
      get :show, :id => @shipping_category.id, :shop_id => @shop.uuid
      response.should be_success
    end

    it "assigns @shipping_category" do
      get :show, :id => @shipping_category.id, :shop_id => @shop.uuid
      assigns(:shipping_category).should == @shipping_category      
    end
  end 

  describe "#new and #create" do
    before(:each) do
      @shipping_category = build(:shipping_category, :shop_id => @shop.uuid)
      ShippingCategory.stub!(:build).and_return(@shipping_category)
    end

    it "access page new" do
      get :new, :shop_id => @shop.uuid
      response.should be_success 
    end

    it "assigns @shipping_category" do
      get :new, :shop_id => @shop.uuid
      assigns(:shipping_category).should be     
    end

    it "access to create" do
      @params = {:shipping_category => {:name => @shipping_category.name}, :shop_id => @shop.uuid}
      lambda {
        post :create, @params
      }.should change(ShippingCategory, :count).by(1) 
    end

    it "redirects after shipping category creation" do
      @params = {:shipping_category => {:name => @shipping_category.name}, :shop_id => @shop.uuid}
      post :create, @params
      response.should redirect_to shop_shipping_categories_path(@shop)
    end

    it "sets flash notice after shipping category creation" do
      @params = {:shipping_category => {:name => @shipping_category.name}, :shop_id => @shop.uuid}
      post :create, @params
      flash[:notice].should be
    end
  end

  describe "#edit and update" do
    before(:each) do
      @shipping_category = create(:shipping_category, :shop_id => @shop.id)
    end

    it "edit" do
      get :edit, :id => @shipping_category.id, :shop_id => @shop.uuid
      response.should be_success
    end

    it "assigns @shipping_category" do
      get :edit, :id => @shipping_category.id, :shop_id => @shop.uuid
      assigns(:shipping_category).should == @shipping_category
    end

    it "does not change shipping categories count" do
      @params = {:id => @shipping_category.id, :shop_id => @shop.uuid, :name => "#{@shipping_category.name}test"}
      lambda {
        put :update, @params
      }.should_not change(ShippingCategory, :count)
    end

    it "redirects after shipping category edition" do
      @params = {:id => @shipping_category.id, :shop_id => @shop.uuid, :name => "#{@shipping_category.name}test"}
      put :update, @params
      response.should redirect_to shop_shipping_categories_path(@shop)
    end

    it "sets flash notice after shipping category edition" do
      @params = {:id => @shipping_category.id, :shop_id => @shop.uuid, :name => "#{@shipping_category.name}test"}
      put :update, @params
      flash[:notice].should be
    end

  end
  
  describe "#destroy" do
    before { @shipping_category = create(:shipping_category, :shop_id => @shop.id) }
    it { expect { delete :destroy, :format => "js", :id => @shipping_category.id, :shop_id => @shop.uuid }.to change{ ShippingCategory.count }.by(-1) }
  end

end
