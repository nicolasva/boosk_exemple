require 'spec_helper'

describe TaxonsController do
  describe "GET /shops/1/taxonomies/1/taxons" do
    specify { get("#{backend_url_root}/shops/1/taxonomies/1/taxons").should be_routable }
    specify { get("#{backend_url_root}/shops/1/taxonomies/1/taxons").should route_to({:action => "index", :controller => "taxons", :shop_id => "1", :taxonomy_id => "1"}) }
  end

  describe "GET /shops/1/taxonomies/1/taxons/new" do
    specify { get("#{backend_url_root}/shops/1/taxonomies/1/taxons/new").should be_routable }
    specify { get("#{backend_url_root}/shops/1/taxonomies/1/taxons/new").should route_to({:action => "new", :controller => "taxons", :shop_id => "1", :taxonomy_id => "1"}) }
  end

  describe "POST /shops/1/taxonomies/1/taxons" do
    specify { post("#{backend_url_root}/shops/1/taxonomies/1/taxons").should be_routable }
    specify { post("#{backend_url_root}/shops/1/taxonomies/1/taxons").should route_to({:action => "create", :controller => "taxons", :shop_id => "1", :taxonomy_id => "1"}) }
  end

  describe "GET /shops/1/taxonomies/1/taxons/1" do
    specify { get("#{backend_url_root}/shops/1/taxonomies/1/taxons/1").should be_routable }
    specify { get("#{backend_url_root}/shops/1/taxonomies/1/taxons/1").should route_to({:action => "show", :controller => "taxons", :shop_id => "1", :taxonomy_id => "1", :id => "1"}) }
  end

  describe "GET /shops/1/taxonomies/1/taxons/1/edit" do
    specify { get("#{backend_url_root}/shops/1/taxonomies/1/taxons/1/edit").should be_routable }
    specify { get("#{backend_url_root}/shops/1/taxonomies/1/taxons/1/edit").should route_to({:action => "edit", :controller => "taxons", :shop_id => "1", :taxonomy_id => "1", :id => "1"}) }
  end

  describe "PUT /shops/1/taxonomies/1/taxons/1" do
    specify { put("#{backend_url_root}/shops/1/taxonomies/1/taxons/1").should be_routable }
    specify { put("#{backend_url_root}/shops/1/taxonomies/1/taxons/1").should route_to({:action => "update", :controller => "taxons", :shop_id => "1", :taxonomy_id => "1", :id => "1"}) }
  end

  describe "DELETE /shops/1/taxonomies/1/taxons/1" do
    specify { delete("#{backend_url_root}/shops/1/taxonomies/1/taxons/1").should be_routable }    
    specify { delete("#{backend_url_root}/shops/1/taxonomies/1/taxons/1").should route_to({:action => "destroy", :controller => "taxons", :shop_id => "1", :taxonomy_id => "1", :id => "1"}) }
  end
end