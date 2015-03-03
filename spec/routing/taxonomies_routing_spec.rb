require 'spec_helper'

describe TaxonomiesController do
  describe "GET /shops/1/taxonomies" do
    specify { get("#{backend_url_root}/shops/1/taxonomies").should be_routable }
    specify { get("#{backend_url_root}/shops/1/taxonomies").should route_to({:action => "index", :controller => "taxonomies", :shop_id => "1"}) }
  end

  describe "GET /shops/1/taxonomies/new" do
    specify { get("#{backend_url_root}/shops/1/taxonomies/new").should be_routable }
    specify { get("#{backend_url_root}/shops/1/taxonomies/new").should route_to({:action => "new", :controller => "taxonomies", :shop_id => "1"}) }
  end

  describe "POST /shops/1/taxonomies" do
    specify { post("#{backend_url_root}/shops/1/taxonomies").should be_routable }
    specify { post("#{backend_url_root}/shops/1/taxonomies").should route_to({:action => "create", :controller => "taxonomies", :shop_id => "1"}) }
  end

  describe "GET /shops/1/taxonomies/1" do
    specify { get("#{backend_url_root}/shops/1/taxonomies/1").should be_routable }
    specify { get("#{backend_url_root}/shops/1/taxonomies/1").should route_to({:action => "show", :controller => "taxonomies", :shop_id => "1", :id => "1"}) }
  end

  describe "GET /shops/1/taxonomies/1/edit" do
    specify { get("#{backend_url_root}/shops/1/taxonomies/1/edit").should be_routable }
    specify { get("#{backend_url_root}/shops/1/taxonomies/1/edit").should route_to({:action => "edit", :controller => "taxonomies", :shop_id => "1", :id => "1"}) }
  end

  describe "PUT /shops/1/taxonomies/1" do
    specify { put("#{backend_url_root}/shops/1/taxonomies/1").should be_routable }
    specify { put("#{backend_url_root}/shops/1/taxonomies/1").should route_to({:action => "update", :controller => "taxonomies", :shop_id => "1", :id => "1"}) }
  end

  describe "DELETE /shops/1/taxonomies/1" do
    specify { delete("#{backend_url_root}/shops/1/taxonomies/1").should be_routable }    
    specify { delete("#{backend_url_root}/shops/1/taxonomies/1").should route_to({:action => "destroy", :controller => "taxonomies", :shop_id => "1", :id => "1"}) }
  end
end
