require "spec_helper"

describe DashboardsController do
  describe "GET /shops/1/dashboards" do
    specify { get("#{backend_url_root}/dashboards").should_not be_routable }
  end

  describe "GET /shops/1/dashboard/new" do
    specify { get("#{backend_url_root}/dashboard/new").should_not be_routable }
  end

  describe "POST /shops/1/dashboard" do
    specify { post("#{backend_url_root}/dashboard").should_not be_routable }
  end

  describe "GET /shops/1/dashboard" do
    specify { get("#{backend_url_root}/dashboard").should be_routable }
    specify { get("#{backend_url_root}/dashboard").should route_to({:action => "show", :controller => "dashboards"}) }
  end

  describe "GET /shops/1/dashboard/edit" do
    specify { get("#{backend_url_root}/dashboard/edit").should_not be_routable }
  end

  describe "PUT /shops/1/dashboard" do
    specify { put("#{backend_url_root}/dashboard").should be_routable }
    specify { put("#{backend_url_root}/dashboard").should route_to({:action => "update", :controller => "dashboards"}) }
  end

  describe "DELETE /shops/1/dashboard" do
    specify { delete("#{backend_url_root}/dashboard").should_not be_routable }    
  end

  describe "GET /" do
    specify { get("#{backend_url_root}").should be_routable }
    specify { get("#{backend_url_root}").should route_to({:action => "show", :controller => "dashboards"}) }
  end

  describe "GET /shops/1/dashboard/translate" do
    specify { get("#{backend_url_root}/dashboard/translate").should be_routable }
    specify { get("#{backend_url_root}/dashboard/translate").should route_to({:action => "translate", :controller => "dashboards"}) }
  end

  describe "GET /shops/1/dashboard/geographic_regions" do
    specify { get("#{backend_url_root}/dashboard/geographic_regions").should be_routable }
    specify { get("#{backend_url_root}/dashboard/geographic_regions").should route_to({:action => "geographic_regions", :controller => "dashboards"}) }
  end

  describe "GET /shops/1/dashboard/translate" do
    specify { get("#{backend_url_root}/dashboard/general_analytics").should be_routable }
    specify { get("#{backend_url_root}/dashboard/general_analytics").should route_to({:action => "general_analytics", :controller => "dashboards"}) }
  end

  describe "GET /shops/1/dashboard/shop_functionnality" do
    specify { get("#{backend_url_root}/dashboard/shop_functionnality").should be_routable }
    specify { get("#{backend_url_root}/dashboard/shop_functionnality").should route_to({:action => "shop_functionnality", :controller => "dashboards"}) }
  end
end