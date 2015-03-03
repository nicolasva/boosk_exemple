require 'spec_helper'

describe ZonesController do

  describe "GET /shops/1/zones" do
    specify { get("#{backend_url_root}/shops/1/zones").should be_routable }
    specify { get("#{backend_url_root}/shops/1/zones").should route_to({:action => "index", :controller => "zones", :shop_id => "1"}) }
  end

  describe "GET /shops/1/zones/new" do
    specify { get("#{backend_url_root}/shops/1/zones/new").should be_routable }
    specify { get("#{backend_url_root}/shops/1/zones/new").should route_to({:action => "new", :controller => "zones", :shop_id => "1"}) }
  end

  describe "POST /shops/1/zones" do
    specify { post("#{backend_url_root}/shops/1/zones").should be_routable }
    specify { post("#{backend_url_root}/shops/1/zones").should route_to({:action => "create", :controller => "zones", :shop_id => "1"}) }
  end

  describe "GET /shops/1/zones/1" do
    specify { get("#{backend_url_root}/shops/1/zones/1").should be_routable }
    specify { get("#{backend_url_root}/shops/1/zones/1").should route_to({:action => "show", :controller => "zones", :shop_id => "1", :id => "1"}) }
  end

  describe "GET /shops/1/zones/1/edit" do
    specify { get("#{backend_url_root}/shops/1/zones/1/edit").should be_routable }
    specify { get("#{backend_url_root}/shops/1/zones/1/edit").should route_to({:action => "edit", :controller => "zones", :shop_id => "1", :id => "1"}) }
  end

  describe "PUT /shops/1/zones/1" do
    specify { put("#{backend_url_root}/shops/1/zones/1").should be_routable }
    specify { put("#{backend_url_root}/shops/1/zones/1").should route_to({:action => "update", :controller => "zones", :shop_id => "1", :id => "1"}) }
  end

  describe "DELETE /shops/1/zones/1" do
    specify { delete("#{backend_url_root}/shops/1/zones/1").should be_routable }    
    specify { delete("#{backend_url_root}/shops/1/zones/1").should route_to({:action => "destroy", :controller => "zones", :shop_id => "1", :id => "1"}) }
  end

  describe "DELETE /shops/1/zones/destroy/all" do
    specify { delete("#{backend_url_root}/shops/1/zones/destroy/all").should be_routable }    
    specify { delete("#{backend_url_root}/shops/1/zones/destroy/all").should route_to({:action => "destroy_all", :controller => "zones", :shop_id => "1"}) }
  end

end