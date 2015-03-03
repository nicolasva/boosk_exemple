require 'spec_helper'

describe Frontoffice::ProductVariantsController do
  before(:each) do
    @user = create(:user)
    @shop = create(:shop, :users => [@user]) 
    @product = create(:product, :shop_id => @shop.id)
  end

  describe "show" do
    before(:each) do
      @product_variant = create(:product_variant, :product_id => @product.id)
    end

    it "access page show" do
      get :show, :id => @product_variant.id, :product_id => @product.id, :shop_id => @shop.uuid, :format => :json
      response.should be_success
    end
  end
end
