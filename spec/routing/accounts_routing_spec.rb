require 'spec_helper'

describe AccountsController do

  describe "GET /accounts" do
    specify { get("#{backend_url_root}/accounts").should_not be_routable }
  end

  describe "GET /accounts/1" do
    specify { get("#{backend_url_root}/accounts/1").should_not be_routable }
  end

  describe "GET /account" do
    specify { get("#{backend_url_root}/account").should be_routable }
    specify { get("#{backend_url_root}/account").should route_to({:controller => "accounts", :action => "show"}) }
  end

  describe "GET /account/new" do
    specify { get("#{backend_url_root}/account/new").should_not be_routable }
  end

  describe "POST /account" do
    specify { post("#{backend_url_root}/account").should_not be_routable }
  end

  describe "GET /account/edit" do
    specify { get("#{backend_url_root}/account/edit").should_not be_routable }
  end

  describe "PUT /account" do
    specify { put("#{backend_url_root}/account").should be_routable }
    specify { put("#{backend_url_root}/account").should route_to({:controller => "accounts", :action => "update"}) }
  end

  describe "DELETE /account" do
    specify { delete("#{backend_url_root}/account").should be_routable }
    specify { delete("#{backend_url_root}/account").should route_to({:controller => "accounts", :action => "destroy"}) }
  end

end