require 'spec_helper'

describe CustomizationsController do

  describe "GET /shops/1/customizations" do
    specify { get("#{backend_url_root}/shops/1/customizations").should_not be_routable }
  end

  describe "GET /shops/1/customization/new" do
    specify { get("#{backend_url_root}/shops/1/customization/new").should_not be_routable }
  end

  describe "POST /shops/1/customization" do
    specify { post("#{backend_url_root}/shops/1/customization").should_not be_routable }
  end

  describe "GET /shops/1/customization" do
    specify { get("#{backend_url_root}/shops/1/customization").should be_routable }
    specify { get("#{backend_url_root}/shops/1/customization").should route_to({:action => "show", :controller => "customizations", :shop_id => "1"}) }
  end

  describe "GET /shops/1/customization/edit" do
    specify { get("#{backend_url_root}/shops/1/customization/edit").should be_routable }
    specify { get("#{backend_url_root}/shops/1/customization/edit").should route_to({:action => "edit", :controller => "customizations", :shop_id => "1"}) }
  end

  describe "PUT /shops/1/customization" do
    specify { put("#{backend_url_root}/shops/1/customization").should be_routable }
    specify { put("#{backend_url_root}/shops/1/customization").should route_to({:action => "update", :controller => "customizations", :shop_id => "1"}) }
  end

  describe "DELETE /shops/1/customization" do
    specify { delete("#{backend_url_root}/shops/1/customization").should_not be_routable }    
  end
end
