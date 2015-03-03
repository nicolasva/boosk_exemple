require 'spec_helper'

describe AnalyticsController do

  describe "GET /analytics" do
    specify { get("#{backend_url_root}/shops/1/analytics").should be_routable }
    specify { get("#{backend_url_root}/shops/1/analytics").should route_to({:controller => "analytics", :action => "index", :shop_id => "1"}) }
  end

  describe "GET /analytics/new" do
    specify { get("#{backend_url_root}/shops/1/analytics/new").should_not be_routable }
  end

  describe "POST /analytics" do
    specify { post("#{backend_url_root}/shops/1/analytics").should_not be_routable }
  end

  describe "GET /analytics/1" do
    specify { get("#{backend_url_root}/shops/1/analytics/1").should_not be_routable }
  end

  describe "GET /analytics/1/edit" do
    specify { get("#{backend_url_root}/shops/1/analytics/1/edit").should_not be_routable }
  end

  describe "PUT /analytics/1" do
    specify { put("#{backend_url_root}/shops/1/analytics/1").should_not be_routable }
  end

  describe "DELETE /analytics/1" do
    specify { delete("#{backend_url_root}/shops/1/analytics/1").should_not be_routable }
  end

end