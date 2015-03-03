require 'spec_helper'

describe Frontoffice::ShopsController do
  before(:each)  do
    @user = create(:user)
    @shop = create(:shop, :users => [@user])
    cookies[:shop_id] = @shop.uuid
    request.host = "#{@shop.name.downcase}.example.com"
  end

  describe "#show" do
    it "access page show" do
      get :show, :id => @shop.uuid
      response.should be_success
    end 
  end
end 
