require 'spec_helper'

describe ShopsController do
  before(:each) do
    @user = create(:user, :plan_id => create(:plan))
    sign_in @user
  end

  describe "#index" do
    before(:each) do
      @shop = create(:shop, :users => [@user])
    end

    it "access page" do
      get :index
      response.should be_success
    end
  end

  describe "#show" do
    before(:each) do
      @shop = create(:shop, :users => [@user])
    end

    it "access page show" do
      get :show, :id => @shop.id
      response.should be_success
    end
  end

  describe "#new and create" do
    before(:each) do
      @shop = build(:shop, :users => [@user])
      Shop.stub!(:build).and_return(@shop)
    end

    it "access page new" do
      get :new
    end

    it "access page create" do
      @params = { :shop => {:name => @shop.name, :baseline => @shop.baseline, :description => @shop.description, :user_id => @user.id } 
      }
      lambda { 
        post :create, @params
      }.should change(Shop, :count).by(1)
    end 
  end

  describe "#edit and update" do
    before(:each) do
      @shop = create(:shop, :users => [@user])
    end 

    it "edit" do
      get :edit, :id => @shop.uuid
    end

    it "update" do
      @params = {:id => @shop.id, :name => @shop.name,
                 :baseline => @shop.baseline, :description => @shop.description, :user_id => @user.id }
      proc{
        put :update, @params
      }.should change(Shop, :count).by(0)
    end
  end


  describe "#destroy" do
    before(:each) do
      @shop = create(:shop, :users => [@user])
      cookies[:shop_id] = @shop.uuid
    end

    it "redirects back" do
      delete :destroy, :id => @shop.uuid
      response.should be_redirect
    end

    it "removes a shop" do
      lambda {
        delete :destroy, :id => @shop.uuid
      }.should change(Shop, :count).by(-1)
    end
  end
end
