require 'spec_helper'

describe TaxRatesController do
  describe "GET /shops/1/tax_rates" do
    specify { get("#{backend_url_root}/shops/1/tax_rates").should be_routable }
    specify { get("#{backend_url_root}/shops/1/tax_rates").should route_to({:action => "index", :controller => "tax_rates", :shop_id => "1"}) }
  end

  describe "GET /shops/1/tax_rates/new" do
    specify { get("#{backend_url_root}/shops/1/tax_rates/new").should be_routable }
    specify { get("#{backend_url_root}/shops/1/tax_rates/new").should route_to({:action => "new", :controller => "tax_rates", :shop_id => "1"}) }
  end

  describe "POST /shops/1/tax_rates" do
    specify { post("#{backend_url_root}/shops/1/tax_rates").should be_routable }
    specify { post("#{backend_url_root}/shops/1/tax_rates").should route_to({:action => "create", :controller => "tax_rates", :shop_id => "1"}) }
  end

  describe "GET /shops/1/tax_rates/1" do
    specify { get("#{backend_url_root}/shops/1/tax_rates/1").should be_routable }
    specify { get("#{backend_url_root}/shops/1/tax_rates/1").should route_to({:action => "show", :controller => "tax_rates", :shop_id => "1", :id => "1"}) }
  end

  describe "GET /shops/1/tax_rates/1/edit" do
    specify { get("#{backend_url_root}/shops/1/tax_rates/1/edit").should be_routable }
    specify { get("#{backend_url_root}/shops/1/tax_rates/1/edit").should route_to({:action => "edit", :controller => "tax_rates", :shop_id => "1", :id => "1"}) }
  end

  describe "PUT /shops/1/tax_rates/1" do
    specify { put("#{backend_url_root}/shops/1/tax_rates/1").should be_routable }
    specify { put("#{backend_url_root}/shops/1/tax_rates/1").should route_to({:action => "update", :controller => "tax_rates", :shop_id => "1", :id => "1"}) }
  end

  describe "DELETE /shops/1/tax_rates/1" do
    specify { delete("#{backend_url_root}/shops/1/tax_rates/1").should be_routable }    
    specify { delete("#{backend_url_root}/shops/1/tax_rates/1").should route_to({:action => "destroy", :controller => "tax_rates", :shop_id => "1", :id => "1"}) }
  end

  describe "DELETE /shops/1/tax_rates/destroy/all" do
    specify { delete("#{backend_url_root}/shops/1/tax_rates/destroy/all").should be_routable }    
    specify { delete("#{backend_url_root}/shops/1/tax_rates/destroy/all").should route_to({:action => "destroy_all", :controller => "tax_rates", :shop_id => "1"}) }    
  end
end