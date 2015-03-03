require 'spec_helper'

describe CustomizationsController do
  before(:each) do
    @user = create(:user, :plan_id => create(:plan))
    @shop = create(:shop, :users => [@user])
    sign_in @user 
  end

  describe "#show" do
    it "access page show" do
      get :show, :shop_id => @shop.uuid
      response.should be_success
    end
  end

  describe "#edit and update" do
    before(:each) do 
      @customization = build(:customization, :shop_id => @shop.id) 
    end

    it "edit" do
      get :edit, :shop_id => @shop.uuid
      response.should be_success
    end
  
    it "update" do
      @params = {:background_color_product_list => @customization.background_color_product_list, 
                 :background_color_product_thumb => @customization.background_color_product_thumb, 
                 :background_color_shop => @customization.background_color_shop, 
                 :background_color_sidebar => @customization.background_color_sidebar, 
                 :baseline_color => @customization.baseline_color, 
                 :border_color => @customization.border_color, 
                 :color_link => @customization.color_link, 
                 :color_link_product => @customization.color_link_product, 
                 :color_text => @customization.color_text, 
                 :color_text_product => @customization.color_text_product, 
                 :created_at => "2012-03-16T09:09:26Z", 
                 :fan_access => @customization.fan_access, 
                 :id => @customization.id, 
                 :logo => {:url => nil}, 
                 :products_per_page => @customization.products_per_page, 
                 :search_engine => @customization.search_engine, 
                 :shop_id => @shop.uuid, 
                 :shutter => {:url => nil}, 
                 :teaser =>{:url => nil}, 
                 :updated_at => "2012-03-16T09:09:26Z", 
                 :customization =>{:id => 1, 
                                   :shop_id => @shop.uuid,
                                   :background_color_shop => @customization.background_color_shop, 
                                   :background_color_product_list => @customization.background_color_product_list, 
                                   :background_color_product_thumb => @customization.background_color_product_thumb, 
                                   :background_color_sidebar => @customization.background_color_sidebar, 
                                   :baseline_color => @customization.baseline_color, 
                                   :border_color => @customization.border_color, 
                                   :color_text => @customization.color_text, 
                                   :color_link => @customization.color_link, 
                                   :color_text_product => @customization.color_text_product, 
                                   :color_link_product => @customization.color_link_product, 
                                   :products_per_page => @customization.products_per_page, 
                                   :fan_access => @customization.fan_access, 
                                   :search_engine => @customization.search_engine, 
                                   :created_at => "2012-03-16T09:09:26Z", 
                                   :updated_at => "2012-03-16T09:09:26Z", 
                                   :logo => {:url => nil}, 
                                   :shutter => {:url => nil}, 
                                   :teaser => {:url => nil}}}
      proc{
        put :update, @params
      }.should change(Customization, :count).by(0)
      flash.should_not be_empty
      response.should be_redirect
    end
  end

end
