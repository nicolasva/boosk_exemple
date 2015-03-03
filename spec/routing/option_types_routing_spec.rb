require 'spec_helper'

describe OptionTypesController do

  describe "GET /shops/1/option_types" do
    specify { get("#{backend_url_root}/shops/1/option_types").should be_routable }
    specify { get("#{backend_url_root}/shops/1/option_types").should route_to({:action => "index", :controller => "option_types", :shop_id => "1"}) }
  end

  describe "GET /shops/1/option_types/new" do
    specify { get("#{backend_url_root}/shops/1/option_types/new").should be_routable }
    specify { get("#{backend_url_root}/shops/1/option_types/new").should route_to({:action => "new", :controller => "option_types", :shop_id => "1"}) }
  end

  describe "POST /shops/1/option_types" do
    specify { post("#{backend_url_root}/shops/1/option_types").should be_routable }
    specify { post("#{backend_url_root}/shops/1/option_types").should route_to({:action => "create", :controller => "option_types", :shop_id => "1"}) }
  end

  describe "GET /shops/1/option_types/1" do
    specify { get("#{backend_url_root}/shops/1/option_types/1").should be_routable }
    specify { get("#{backend_url_root}/shops/1/option_types/1").should route_to({:action => "show", :controller => "option_types", :shop_id => "1", :id => "1"}) }
  end

  describe "GET /shops/1/option_types/1/edit" do
    specify { get("#{backend_url_root}/shops/1/option_types/1/edit").should be_routable }
    specify { get("#{backend_url_root}/shops/1/option_types/1/edit").should route_to({:action => "edit", :controller => "option_types", :shop_id => "1", :id => "1"}) }
  end

  describe "PUT /shops/1/option_types/1" do
    specify { put("#{backend_url_root}/shops/1/option_types/1").should be_routable }
    specify { put("#{backend_url_root}/shops/1/option_types/1").should route_to({:action => "update", :controller => "option_types", :shop_id => "1", :id => "1"}) }
  end

  describe "DELETE /shops/1/option_types/1" do
    specify { delete("#{backend_url_root}/shops/1/option_types/1").should be_routable }    
    specify { delete("#{backend_url_root}/shops/1/option_types/1").should route_to({:action => "destroy", :controller => "option_types", :shop_id => "1", :id => "1"}) }
  end

  describe "DELETE /shops/1/option_types/destroy/all" do
    specify { delete("#{backend_url_root}/shops/1/option_types/destroy/all").should be_routable }    
    specify { delete("#{backend_url_root}/shops/1/option_types/destroy/all").should route_to({:action => "destroy_all", :controller => "option_types", :shop_id => "1"}) }
  end
end