require 'spec_helper'

describe ProductVariantsController do
  describe "GET /shops/1/products/1/product_variants" do
    specify { get("#{backend_url_root}/shops/1/products/1/product_variants").should be_routable }
    specify { get("#{backend_url_root}/shops/1/products/1/product_variants").should route_to({:action => "index", :controller => "product_variants", :shop_id => "1", :product_id => "1"}) }
  end

  describe "GET /shops/1/products/1/product_variants/new" do
    specify { get("#{backend_url_root}/shops/1/products/1/product_variants/new").should be_routable }
    specify { get("#{backend_url_root}/shops/1/products/1/product_variants/new").should route_to({:action => "new", :controller => "product_variants", :shop_id => "1", :product_id => "1"}) }
  end

  describe "POST /shops/1/products/1/product_variants" do
    specify { post("#{backend_url_root}/shops/1/products/1/product_variants").should be_routable }
    specify { post("#{backend_url_root}/shops/1/products/1/product_variants").should route_to({:action => "create", :controller => "product_variants", :shop_id => "1", :product_id => "1"}) }
  end

  describe "GET /shops/1/products/1/product_variants/1" do
    #FIXME this route should not be routable; currently, it routes to Frontoffice::ProductVariantsController.
    #specify { get("#{backend_url_root}/shops/1/products/1/product_variants/1").should_not be_routable }
  end

  describe "GET /shops/1/products/1/product_variants/1/edit" do
    specify { get("#{backend_url_root}/shops/1/products/1/product_variants/1/edit").should be_routable }
    specify { get("#{backend_url_root}/shops/1/products/1/product_variants/1/edit").should route_to({:action => "edit", :controller => "product_variants", :shop_id => "1", :product_id => "1", :id => "1"}) }
  end

  describe "PUT /shops/1/products/1/product_variants/1" do
    specify { put("#{backend_url_root}/shops/1/products/1/product_variants/1").should be_routable }
    specify { put("#{backend_url_root}/shops/1/products/1/product_variants/1").should route_to({:action => "update", :controller => "product_variants", :shop_id => "1", :product_id => "1", :id => "1"}) }
  end

  describe "DELETE /shops/1/products/1/product_variants/1" do
    specify { delete("#{backend_url_root}/shops/1/products/1/product_variants/1").should be_routable }    
    specify { delete("#{backend_url_root}/shops/1/products/1/product_variants/1").should route_to({:action => "destroy", :controller => "product_variants", :shop_id => "1", :product_id => "1", :id => "1"}) }
  end
end
