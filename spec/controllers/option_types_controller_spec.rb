require 'spec_helper'

describe OptionTypesController do
  before(:each) do
    @user = create(:user, :plan_id => create(:plan))
    @shop = create(:shop, :users => [@user])
    sign_in @user
  end

  describe "#index" do
    before(:each) do
      @option_type = create(:option_type, :shop_id => @shop.id)
    end

    it "access page" do
      get :index, :shop_id => @shop.uuid
      response.should be_success
    end   
  end

  describe "#show" do
    before(:each) do
      @option_type = create(:option_type, :shop_id => @shop.id)
    end

    it "access page show" do
      get :show, :id => @option_type.id, :shop_id => @shop.uuid
      response.should be_success
    end
  end 

  describe "#new and create" do
    before(:each) do 
      @option_type = create(:option_type, :shop_id => @shop.id)
    end

    it "access page new" do
      get :new, :shop_id => @option_type.shop.uuid
      response.should be_success
    end

    it "access page create" do
      @params = {:option_type => {:shop_id => @shop.id, :name => @option_type.name, :value=>["1234", "98977", "12356677"]}, :shop_id => @shop.uuid}
      lambda {
        post :create, @params
      }.should change(OptionType, :count).by(3) 
    end 
  end

  describe "#edit and update" do
    before(:each) do
      @option_type = create(:option_type, :shop_id => @shop.id)
    end

    it "edit" do
      get :edit, :shop_id => @option_type.shop.uuid, :id => @option_type.id
      response.should be_success
    end

    it "update" do
      @params_update = {:type => @option_type.name, :values =>[{:created_at => @option_type.created_at, :id => @option_type.id, :name => @option_type.name, :shop_id => @option_type.shop_id, :updated_at => "2012-03-16T16:50:21Z", :value => @option_type.value}], :id => @option_type.name, :option_type => {:name => @option_type.name, :option => [{:id => @option_type.id, :value => @option_type.value}]}, :shop_id => @option_type.shop.uuid}
      proc{
        put :update, @params_update
      } 
    end
  end

  describe "#destroy" do
    before(:each) do
      @option_type = create(:option_type, :shop_id => @shop.id)
    end

    it "removes an option type" do
      @params = {:format => "js", :id => @option_type.name, :shop_id => @option_type.shop.uuid}
      lambda {
        delete :destroy, @params
      }.should change(OptionType, :count).by(-1)
    end
  end
end
