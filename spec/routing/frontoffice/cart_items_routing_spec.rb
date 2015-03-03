require 'spec_helper'

describe Frontoffice::CartItemsController do

  describe "GET /facebook/shops/1/cart_items" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/cart_items").should_not be_routable }
  end

  describe "GET /facebook/shops/1/cart_items/new" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/cart_items/new").should_not be_routable }
  end

  describe "POST /facebook/shops/1/cart_items" do
    specify { post("#{frontoffice_url_root}/facebook/shops/1/cart_items").should_not be_routable }
  end

  describe "GET /facebook/shops/1/cart_items/1" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/cart_items/1").should_not be_routable }
  end

  describe "GET /facebook/shops/1/cart_items/1/edit" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/cart_items/1/edit").should_not be_routable }
  end

  describe "PUT /facebook/shops/1/cart_items/1" do
    specify { put("#{frontoffice_url_root}/facebook/shops/1/cart_items/1").should_not be_routable }
  end

  describe "DELETE /facebook/shops/1/cart_items/1" do
    specify { delete("#{frontoffice_url_root}/facebook/shops/1/cart_items/1").should_not be_routable }
  end

  describe "POST /facebook/shops/1/add_to_cart" do
    specify { post("#{frontoffice_url_root}/facebook/shops/1/add_to_cart").should be_routable }
    specify { post("#{frontoffice_url_root}/facebook/shops/1/add_to_cart").should route_to({:controller => "frontoffice/cart_items", :action => "create", :shop_id => "1", :ui => "facebook"}) }
  end

  describe "POST /facebook/shops/1/update_to_cart" do
    specify { post("#{frontoffice_url_root}/facebook/shops/1/update_to_cart").should be_routable }
    specify { post("#{frontoffice_url_root}/facebook/shops/1/update_to_cart").should route_to({:controller => "frontoffice/cart_items", :action => "update", :shop_id => "1", :ui => "facebook"}) }
  end

  describe "DELETE /facebook/shops/1/delete_to_cart/2" do
    specify { delete("#{frontoffice_url_root}/facebook/shops/1/delete_to_cart/2").should be_routable }
    specify { delete("#{frontoffice_url_root}/facebook/shops/1/delete_to_cart/2").should route_to({:controller => "frontoffice/cart_items", :action => "destroy", :shop_id => "1", :id => "2", :ui => "facebook"}) }
  end

  describe "GET /facebook/shops/1/show_cart" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/show_cart").should be_routable }    
    specify { get("#{frontoffice_url_root}/facebook/shops/1/show_cart").should route_to({:controller => "frontoffice/cart_items", :action => "show", :shop_id => "1", :ui => "facebook"}) }    
  end

  describe "GET /mobile/shops/1/cart_items" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/cart_items").should_not be_routable }
  end

  describe "GET /mobile/shops/1/cart_items/new" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/cart_items/new").should_not be_routable }
  end

  describe "POST /mobile/shops/1/cart_items" do
    specify { post("#{frontoffice_url_root}/mobile/shops/1/cart_items").should_not be_routable }
  end

  describe "GET /mobile/shops/1/cart_items/1" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/cart_items/1").should_not be_routable }
  end

  describe "GET /mobile/shops/1/cart_items/1/edit" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/cart_items/1/edit").should_not be_routable }
  end

  describe "PUT /mobile/shops/1/cart_items/1" do
    specify { put("#{frontoffice_url_root}/mobile/shops/1/cart_items/1").should_not be_routable }
  end

  describe "DELETE /mobile/shops/1/cart_items/1" do
    specify { delete("#{frontoffice_url_root}/mobile/shops/1/cart_items/1").should_not be_routable }
  end

  describe "POST /mobile/shops/1/add_to_cart" do
    specify { post("#{frontoffice_url_root}/mobile/shops/1/add_to_cart").should be_routable }
    specify { post("#{frontoffice_url_root}/mobile/shops/1/add_to_cart").should route_to({:controller => "frontoffice/cart_items", :action => "create", :shop_id => "1", :ui => "mobile"}) }
  end

  describe "POST /mobile/shops/1/update_to_cart" do
    specify { post("#{frontoffice_url_root}/mobile/shops/1/update_to_cart").should be_routable }
    specify { post("#{frontoffice_url_root}/mobile/shops/1/update_to_cart").should route_to({:controller => "frontoffice/cart_items", :action => "update", :shop_id => "1", :ui => "mobile"}) }
  end

  describe "DELETE /mobile/shops/1/delete_to_cart/2" do
    specify { delete("#{frontoffice_url_root}/mobile/shops/1/delete_to_cart/2").should be_routable }
    specify { delete("#{frontoffice_url_root}/mobile/shops/1/delete_to_cart/2").should route_to({:controller => "frontoffice/cart_items", :action => "destroy", :shop_id => "1", :id => "2", :ui => "mobile"}) }
  end

  describe "GET /mobile/shops/1/show_cart" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/show_cart").should be_routable }
    specify { get("#{frontoffice_url_root}/mobile/shops/1/show_cart").should route_to({:controller => "frontoffice/cart_items", :action => "show", :shop_id => "1", :ui => "mobile"}) }
  end
end
