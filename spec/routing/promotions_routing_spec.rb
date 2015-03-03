require 'spec_helper'

describe PromotionsController do
  describe "GET /shops/1/promotions" do
    specify { get("#{backend_url_root}/shops/1/promotions").should be_routable }
    specify { get("#{backend_url_root}/shops/1/promotions").should route_to({:action => "index", :controller => "promotions", :shop_id => "1"}) }
  end

  describe "GET /shops/1/promotions/new" do
    specify { get("#{backend_url_root}/shops/1/promotions/new").should be_routable }
    specify { get("#{backend_url_root}/shops/1/promotions/new").should route_to({:action => "new", :controller => "promotions", :shop_id => "1"}) }
  end

  describe "POST /shops/1/promotions" do
    specify { post("#{backend_url_root}/shops/1/promotions").should be_routable }
    specify { post("#{backend_url_root}/shops/1/promotions").should route_to({:action => "create", :controller => "promotions", :shop_id => "1"}) }
  end

  describe "GET /shops/1/promotions/1" do
    specify { get("#{backend_url_root}/shops/1/promotions/1").should be_routable }
    specify { get("#{backend_url_root}/shops/1/promotions/1").should route_to({:action => "show", :controller => "promotions", :shop_id => "1", :id => "1"}) }
  end

  describe "GET /shops/1/promotions/1/edit" do
    specify { get("#{backend_url_root}/shops/1/promotions/1/edit").should be_routable }
    specify { get("#{backend_url_root}/shops/1/promotions/1/edit").should route_to({:action => "edit", :controller => "promotions", :shop_id => "1", :id => "1"}) }
  end

  describe "PUT /shops/1/promotions/1" do
    specify { put("#{backend_url_root}/shops/1/promotions/1").should be_routable }
    specify { put("#{backend_url_root}/shops/1/promotions/1").should route_to({:action => "update", :controller => "promotions", :shop_id => "1", :id => "1"}) }
  end

  describe "DELETE /shops/1/promotions/1" do
    specify { delete("#{backend_url_root}/shops/1/promotions/1").should be_routable }    
    specify { delete("#{backend_url_root}/shops/1/promotions/1").should route_to({:action => "destroy", :controller => "promotions", :shop_id => "1", :id => "1"}) }
  end

  describe "DELETE /shops/1/tax_rates/destroy/all" do
    specify { delete("#{backend_url_root}/shops/1/tax_rates/destroy/all").should be_routable }    
    specify { delete("#{backend_url_root}/shops/1/tax_rates/destroy/all").should route_to({:action => "destroy_all", :controller => "tax_rates", :shop_id => "1"}) }    
  end

end