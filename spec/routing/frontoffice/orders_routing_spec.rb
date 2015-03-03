require 'spec_helper'

describe Frontoffice::OrdersController do
  describe "GET /facebook/orders" do
    specify { get("#{frontoffice_url_root}/facebook/orders").should_not be_routable }
  end

  describe "GET /facebook/orders/new" do
    specify { get("#{frontoffice_url_root}/facebook/orders/new").should_not be_routable }
  end

  describe "POST /facebook/orders" do
    specify { post("#{frontoffice_url_root}/facebook/orders").should be_routable }
    specify { post("#{frontoffice_url_root}/facebook/orders").should route_to({:controller => "frontoffice/orders", :action => "create", :ui => "facebook"}) }
  end

  describe "GET /facebook/orders/1" do
    specify { get("#{frontoffice_url_root}/facebook/orders/1").should be_routable }
    specify { get("#{frontoffice_url_root}/facebook/orders/1").should route_to({:controller => "frontoffice/orders", :action => "show", :ui => "facebook", :id => "1"}) }
  end

  describe "GET /facebook/orders/1/edit" do
    specify { get("#{frontoffice_url_root}/facebook/orders/1/edit").should_not be_routable }
  end

  describe "PUT /facebook/orders/1" do
    specify { put("#{frontoffice_url_root}/facebook/orders/1").should_not be_routable }
  end

  describe "DELETE /facebook/orders/1" do
    specify { delete("#{frontoffice_url_root}/facebook/orders/1").should_not be_routable }
  end

  describe "GET /facebook/orders/payment_successfully" do
    specify { get("#{frontoffice_url_root}/facebook/orders/payment_successfully").should be_routable }
    specify { get("#{frontoffice_url_root}/facebook/orders/payment_successfully").should route_to({:controller => "frontoffice/orders", :action => "payment_successfully", :ui => "facebook"}) }
  end

  describe "GET /facebook/orders/payment_canceled" do
    specify { get("#{frontoffice_url_root}/facebook/orders/payment_canceled").should be_routable }
    specify { get("#{frontoffice_url_root}/facebook/orders/payment_canceled").should route_to({:controller => "frontoffice/orders", :action => "payment_canceled", :ui => "facebook"}) }
  end

  describe "POST /facebook/orders/ipn_notification" do
    specify { post("#{frontoffice_url_root}/facebook/orders/ipn_notification").should be_routable }
    specify { post("#{frontoffice_url_root}/facebook/orders/ipn_notification").should route_to({:controller => "frontoffice/orders", :action => "ipn_notification", :ui => "facebook"}) }
  end

  describe "POST /facebook/new_order" do
    specify { post("#{frontoffice_url_root}/facebook/new_order").should be_routable }
    specify { post("#{frontoffice_url_root}/facebook/new_order").should route_to({:controller => "frontoffice/orders", :action => "create", :ui => "facebook"}) }
  end

  describe "GET /mobile/orders" do
    specify { get("#{frontoffice_url_root}/mobile/orders").should_not be_routable }
  end

  describe "GET /mobile/orders/new" do
    specify { get("#{frontoffice_url_root}/mobile/orders/new").should_not be_routable }
  end

  describe "POST /mobile/orders" do
    specify { post("#{frontoffice_url_root}/mobile/orders").should be_routable }
    specify { post("#{frontoffice_url_root}/mobile/orders").should route_to({:controller => "frontoffice/orders", :action => "create", :ui => "mobile"}) }
  end

  describe "GET /mobile/orders/1" do
    specify { get("#{frontoffice_url_root}/mobile/orders/1").should be_routable }
    specify { get("#{frontoffice_url_root}/mobile/orders/1").should route_to({:controller => "frontoffice/orders", :action => "show", :ui => "mobile", :id => "1"}) }
  end

  describe "GET /mobile/orders/1/edit" do
    specify { get("#{frontoffice_url_root}/mobile/orders/1/edit").should_not be_routable }
  end

  describe "PUT /mobile/orders/1" do
    specify { put("#{frontoffice_url_root}/mobile/orders/1").should_not be_routable }
  end

  describe "DELETE /mobile/orders/1" do
    specify { delete("#{frontoffice_url_root}/mobile/orders/1").should_not be_routable }
  end

  describe "GET /mobile/orders/payment_successfully" do
    specify { get("#{frontoffice_url_root}/mobile/orders/payment_successfully").should be_routable }
    specify { get("#{frontoffice_url_root}/mobile/orders/payment_successfully").should route_to({:controller => "frontoffice/orders", :action => "payment_successfully", :ui => "mobile"}) }
  end

  describe "GET /mobile/orders/payment_canceled" do
    specify { get("#{frontoffice_url_root}/mobile/orders/payment_canceled").should be_routable }
    specify { get("#{frontoffice_url_root}/mobile/orders/payment_canceled").should route_to({:controller => "frontoffice/orders", :action => "payment_canceled", :ui => "mobile"}) }
  end

  describe "POST /mobile/orders/ipn_notification" do
    specify { post("#{frontoffice_url_root}/mobile/orders/ipn_notification").should be_routable }
    specify { post("#{frontoffice_url_root}/mobile/orders/ipn_notification").should route_to({:controller => "frontoffice/orders", :action => "ipn_notification", :ui => "mobile"}) }
  end

  describe "POST /mobile/new_order" do
    specify { post("#{frontoffice_url_root}/mobile/new_order").should be_routable }
    specify { post("#{frontoffice_url_root}/mobile/new_order").should route_to({:controller => "frontoffice/orders", :action => "create", :ui => "mobile"}) }
  end
end