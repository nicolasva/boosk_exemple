require 'spec_helper'

describe ShippingMethodsController do
  describe "GET /shops/1/shipping_methods" do
    specify { get("#{backend_url_root}/shops/1/shipping_methods").should be_routable }
    specify { get("#{backend_url_root}/shops/1/shipping_methods").should route_to({:action => "index", :controller => "shipping_methods", :shop_id => "1"}) }
  end

  describe "GET /shops/1/shipping_methods/new" do
    specify { get("#{backend_url_root}/shops/1/shipping_methods/new").should be_routable }
    specify { get("#{backend_url_root}/shops/1/shipping_methods/new").should route_to({:action => "new", :controller => "shipping_methods", :shop_id => "1"}) }
  end

  describe "POST /shops/1/shipping_methods" do
    specify { post("#{backend_url_root}/shops/1/shipping_methods").should be_routable }
    specify { post("#{backend_url_root}/shops/1/shipping_methods").should route_to({:action => "create", :controller => "shipping_methods", :shop_id => "1"}) }
  end

  describe "GET /shops/1/shipping_methods/1" do
    specify { get("#{backend_url_root}/shops/1/shipping_methods/1").should be_routable }
    specify { get("#{backend_url_root}/shops/1/shipping_methods/1").should route_to({:action => "show", :controller => "shipping_methods", :shop_id => "1", :id => "1"}) }
  end

  describe "GET /shops/1/shipping_methods/1/edit" do
    specify { get("#{backend_url_root}/shops/1/shipping_methods/1/edit").should be_routable }
    specify { get("#{backend_url_root}/shops/1/shipping_methods/1/edit").should route_to({:action => "edit", :controller => "shipping_methods", :shop_id => "1", :id => "1"}) }
  end

  describe "PUT /shops/1/shipping_methods/1" do
    specify { put("#{backend_url_root}/shops/1/shipping_methods/1").should be_routable }
    specify { put("#{backend_url_root}/shops/1/shipping_methods/1").should route_to({:action => "update", :controller => "shipping_methods", :shop_id => "1", :id => "1"}) }
  end

  describe "DELETE /shops/1/shipping_methods/1" do
    specify { delete("#{backend_url_root}/shops/1/shipping_methods/1").should be_routable }    
    specify { delete("#{backend_url_root}/shops/1/shipping_methods/1").should route_to({:action => "destroy", :controller => "shipping_methods", :shop_id => "1", :id => "1"}) }
  end

  describe "DELETE /shops/1/shipping_methods/destroy/all" do
    specify { delete("#{backend_url_root}/shops/1/shipping_methods/destroy/all").should be_routable }    
    specify { delete("#{backend_url_root}/shops/1/shipping_methods/destroy/all").should route_to({:action => "destroy_all", :controller => "shipping_methods", :shop_id => "1"}) }    
  end
end
