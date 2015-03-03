require 'spec_helper'

describe ProductsController do
  before(:each) do
    @user = create(:user, :plan_id => create(:plan))
    @shop = create(:shop, :users => [@user])
    sign_in @user
  end

  describe "#index" do
    before(:each) do
      @product = @shop.products.create
    end  

    it "access page" do
      get :index, :shop_id => @product.shop.uuid
      response.should be_success
    end
  end

  describe "#show" do
    before(:each) do
      @product = create(:product, :shop_id => @shop.id)
    end

    it "access page show" do
      get :show, :shop_id => @product.shop.uuid, :id => @product.uuid
      response.should be_redirect
    end
  end 

  describe "#new and create" do
    before(:each) do
      @product = create(:product, :shop_id => @shop.id)
      @product_variant = create(:product_variant, :product_id => @product.id)
      Product.stub!(:build).and_return(@product)
    end

    it "access page new" do
      get :new, :shop_id => @product.shop.uuid
      response.should be_success 
    end

    it "access to create" do
      @params = {:product =>{:shop_id => @product.shop_id, 
                             :name => @product.name, 
                             :description => @product.description, 
                             :highlight => @product.highlight, 
                             :permalink => @product.permalink, 
                             :product_variants_attributes => [{
                                                                :price =>@product_variant.price, 
                                                                :sku => @product_variant.sku, 
                                                                :quantity => @product_variant.quantity, 
                                                                :weight => @product_variant.weight, 
                                                                :height => @product_variant.height, 
                                                                :depth => @product_variant.depth, 
                                                                :width => @product_variant.width 
                                                              }]
        }, 
                             :shop_id => @product.shop.uuid}
      lambda {
        post :create, @params
      }.should change(Product, :count).by(1) 
    end
  end

  describe "#edit and update" do
    before(:each) do
      @product = create(:product, :shop_id => @shop.id)
      @product_variant = create(:product_variant, :product_id => @product.id)
    end

    it "edit" do
      get :edit, :id => @product.id, :shop_id => @product.shop.uuid
      response.should be_success
    end

    it "update" do
      @params = {
          :id => @product.id,
          :shop_id => @product.shop.uuid, 
          :name => @product.name, 
          :description => @product.description, 
          :product_variants => [{
                                  :price => @product_variant.price, 
                                  :height => @product_variant.height, 
                                  :width => @product_variant.width, 
                                  :weight => @product_variant.weight,
                                  :quantity => @product_variant.quantity,
                                  :option_types_attributes => create(:option_type, :shop_id => @shop.id),
                                  :pictures_attributes => create(:product_variant_picture)
                                }], 
          :product_variant =>{:price => @product_variant.price, 
            :sku => @product_variant.sku, 
            :weight => @product_variant.weight, 
            :height => @product_variant.height, 
            :width => @product_variant.width}
      }
      proc{
        put :update, @params
      }.should change(Product, :count).by(0)
      flash.should_not be_empty 
      response.should be_redirect   
    end
  end
  
  describe "#destroy" do
    before(:each) do
      @product = create(:product, :shop_id => @shop.id)
    end 

    it "removes a product" do
      lambda {
        delete :destroy, :format => "js", :id => @product.id, :shop_id => @product.shop.uuid
      }.should change(Product, :count).by(-1)
    end
  end
end
