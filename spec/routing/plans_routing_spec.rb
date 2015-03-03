require 'spec_helper'

describe PlansController do

  describe "GET /plans" do
    specify { get("#{backend_url_root}/plans").should be_routable }
    specify { get("#{backend_url_root}/plans").should route_to({:action => "index", :controller => "plans"}) }
  end

  describe "GET /plans/new" do
    specify { get("#{backend_url_root}/plans/new").should_not be_routable }
  end

  describe "POST /plans" do
    specify { post("#{backend_url_root}/plans").should be_routable }
    specify { post("#{backend_url_root}/plans").should route_to({:action => "create", :controller => "plans"}) }
  end

  describe "GET /plans/1" do
    specify { get("#{backend_url_root}/plans/1").should_not be_routable }
  end

  describe "GET /plans/1/edit" do
    specify { get("#{backend_url_root}/plans/1/edit").should_not be_routable }
  end

  describe "PUT /plans/1" do
    specify { put("#{backend_url_root}/plans/1").should_not be_routable }
  end

  describe "DELETE /plans/1" do
    specify { delete("#{backend_url_root}/plans/1").should_not be_routable }    
  end

  describe "POST /plans/ipn_notification" do
    specify { post("#{backend_url_root}/plans/ipn_notification").should be_routable }
    specify { post("#{backend_url_root}/plans/ipn_notification").should route_to({:action => "ipn_notification", :controller => "plans"}) }
  end

  describe "GET /plans/paypal_success_url" do
    specify { get("#{backend_url_root}/plans/paypal_success_url").should be_routable }
    specify { get("#{backend_url_root}/plans/paypal_success_url").should route_to({:action => "paypal_success_url", :controller => "plans"}) }
  end

end