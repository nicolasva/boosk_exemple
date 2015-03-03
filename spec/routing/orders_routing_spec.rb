require 'spec_helper'

describe OrdersController do

 describe "GET /shops/1/orders" do
    specify { get("#{backend_url_root}/shops/1/orders").should be_routable }
    specify { get("#{backend_url_root}/shops/1/orders").should route_to({:action => "index", :controller => "orders", :shop_id => "1"}) }
  end

  describe "GET /shops/1/orders/new" do
    specify { get("#{backend_url_root}/shops/1/orders/new").should_not be_routable }
  end

  describe "POST /shops/1/orders" do
    specify { post("#{backend_url_root}/shops/1/orders").should_not be_routable }
  end

  describe "GET /shops/1/orders/1" do
    specify { get("#{backend_url_root}/shops/1/orders/1").should be_routable }
    specify { get("#{backend_url_root}/shops/1/orders/1").should route_to({:action => "show", :controller => "orders", :shop_id => "1", :id => "1"}) }
  end

  describe "GET /shops/1/orders/1/edit" do
    specify { get("#{backend_url_root}/shops/1/orders/1/edit").should_not be_routable }
  end

  describe "PUT /shops/1/orders/1" do
    specify { put("#{backend_url_root}/shops/1/orders/1").should be_routable }
    specify { put("#{backend_url_root}/shops/1/orders/1").should route_to({:action => "update", :controller => "orders", :shop_id => "1", :id => "1"}) }
  end

  describe "DELETE /shops/1/orders/1" do
    specify { delete("#{backend_url_root}/shops/1/orders/1").should_not be_routable }    
  end

  describe "PUT /shops/1/orders/update/all" do
    specify { put("#{backend_url_root}/shops/1/orders/update/all").should be_routable }    
    specify { put("#{backend_url_root}/shops/1/orders/update/all").should route_to({:action => "update_all", :controller => "orders", :shop_id => "1"}) }
  end
end
