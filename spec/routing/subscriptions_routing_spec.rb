require 'spec_helper'

describe SubscriptionsController do

  describe "GET /subscriptions" do
    specify { get("#{backend_url_root}/subscriptions").should_not be_routable }
  end

  describe "GET /subscriptions/1" do
    specify { get("#{backend_url_root}/subscriptions/1").should_not be_routable }
  end

  describe "GET /subscription" do
    specify { get("#{backend_url_root}/subscription").should be_routable }
    specify { get("#{backend_url_root}/subscription").should route_to({:controller => "subscriptions", :action => "new"}) }
  end

  describe "GET /subscription/new" do
    specify { get("#{backend_url_root}/subscription/new").should be_routable }
    specify { get("#{backend_url_root}/subscription/new").should route_to({:controller => "subscriptions", :action => "new"}) }
  end

  describe "POST /subscription" do
    specify { post("#{backend_url_root}/subscription").should be_routable }
    specify { post("#{backend_url_root}/subscription").should route_to({:controller => "subscriptions", :action => "create"}) }
  end

  describe "GET /subscription/edit" do
    specify { get("#{backend_url_root}/subscription/edit").should be_routable }
    specify { get("#{backend_url_root}/subscription/edit").should route_to({:controller => "subscriptions", :action => "edit"}) }
  end

  describe "PUT /subscription" do
    specify { put("#{backend_url_root}/subscription").should be_routable }
    specify { put("#{backend_url_root}/subscription").should route_to({:controller => "subscriptions", :action => "update"}) }
  end

  describe "DELETE /subscription" do
    specify { delete("#{backend_url_root}/subscription").should_not be_routable }
  end

end