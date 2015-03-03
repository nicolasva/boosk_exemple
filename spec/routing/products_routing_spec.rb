require 'spec_helper'

describe ProductsController do
  describe "GET /shops/1/products" do
    specify { get("#{backend_url_root}/shops/1/products").should be_routable }
    specify { get("#{backend_url_root}/shops/1/products").should route_to({:action => "index", :controller => "products", :shop_id => "1"}) }
  end

  describe "GET /shops/1/products/new" do
    specify { get("#{backend_url_root}/shops/1/products/new").should be_routable }
    specify { get("#{backend_url_root}/shops/1/products/new").should route_to({:action => "new", :controller => "products", :shop_id => "1"}) }
  end

  describe "POST /shops/1/products" do
    specify { post("#{backend_url_root}/shops/1/products").should be_routable }
    specify { post("#{backend_url_root}/shops/1/products").should route_to({:action => "create", :controller => "products", :shop_id => "1"}) }
  end

  describe "GET /shops/1/products/1" do
    specify { get("#{backend_url_root}/shops/1/products/1").should be_routable }
    specify { get("#{backend_url_root}/shops/1/products/1").should route_to({:action => "show", :controller => "products", :shop_id => "1", :id => "1"}) }
  end

  describe "GET /shops/1/products/1/edit" do
    specify { get("#{backend_url_root}/shops/1/products/1/edit").should be_routable }
    specify { get("#{backend_url_root}/shops/1/products/1/edit").should route_to({:action => "edit", :controller => "products", :shop_id => "1", :id => "1"}) }
  end

  describe "PUT /shops/1/products/1" do
    specify { put("#{backend_url_root}/shops/1/products/1").should be_routable }
    specify { put("#{backend_url_root}/shops/1/products/1").should route_to({:action => "update", :controller => "products", :shop_id => "1", :id => "1"}) }
  end

  describe "DELETE /shops/1/products/1" do
    specify { delete("#{backend_url_root}/shops/1/products/1").should be_routable }    
    specify { delete("#{backend_url_root}/shops/1/products/1").should route_to({:action => "destroy", :controller => "products", :shop_id => "1", :id => "1"}) }
  end

  describe "DELETE /shops/1/products/destroy/all" do
    specify { delete("#{backend_url_root}/shops/1/products/destroy/all").should be_routable }    
    specify { delete("#{backend_url_root}/shops/1/products/destroy/all").should route_to({:action => "destroy_all", :controller => "products", :shop_id => "1"}) }
  end

  describe "GET /shops/1/products/import" do
    specify { get("#{backend_url_root}/shops/1/products/import").should be_routable }
    specify { get("#{backend_url_root}/shops/1/products/import").should route_to({:action => "import", :controller => "products", :shop_id => "1"}) }
  end
end
