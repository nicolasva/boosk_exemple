require 'spec_helper'

describe ShopsController do
  describe "GET /shops" do
    specify { get("#{backend_url_root}/shops").should be_routable }
    specify { get("#{backend_url_root}/shops").should route_to({:action => "index", :controller => "shops"}) }
  end

  describe "GET /shops/new" do
    specify { get("#{backend_url_root}/shops/new").should be_routable }
    specify { get("#{backend_url_root}/shops/new").should route_to({:action => "new", :controller => "shops"}) }
  end

  describe "POST /shops" do
    specify { post("#{backend_url_root}/shops").should be_routable }
    specify { post("#{backend_url_root}/shops").should route_to({:action => "create", :controller => "shops"}) }
  end

  describe "GET /shops/1" do
    specify { get("#{backend_url_root}/shops/1").should be_routable }
    specify { get("#{backend_url_root}/shops/1").should route_to({:action => "show", :controller => "shops", :id => "1"}) }
  end

  describe "GET /shops/1/edit" do
    specify { get("#{backend_url_root}/shops/1/edit").should be_routable }
    specify { get("#{backend_url_root}/shops/1/edit").should route_to({:action => "edit", :controller => "shops", :id => "1"}) }
  end

  describe "PUT /shops/1" do
    specify { put("#{backend_url_root}/shops/1").should be_routable }
    specify { put("#{backend_url_root}/shops/1").should route_to({:action => "update", :controller => "shops", :id => "1"}) }
  end

  describe "DELETE /shops/1" do
    specify { delete("#{backend_url_root}/shops/1").should be_routable }    
    specify { delete("#{backend_url_root}/shops/1").should route_to({:action => "destroy", :controller => "shops", :id => "1"}) }
  end
end
