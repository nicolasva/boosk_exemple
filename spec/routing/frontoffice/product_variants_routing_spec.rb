require 'spec_helper'

describe Frontoffice::ProductVariantsController do

  describe "GET /facebook/shops/1/products/2/product_variants" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/2/product_variants").should_not be_routable }
  end

  describe "GET /facebook/shops/1/products/2/product_variants/new" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/2/product_variants/new").should_not be_routable }
  end

  describe "POST /facebook/shops/1/products/2/product_variants" do
    specify { post("#{frontoffice_url_root}/facebook/shops/1/products/2/product_variants").should_not be_routable }
  end

  describe "GET /facebook/shops/1/products/2/product_variants/3" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/2/product_variants/3").should be_routable }
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/2/product_variants/3").should route_to({controller: "frontoffice/product_variants", action: "show", shop_id: "1", product_id: "2", id: "3", ui: "facebook"}) }
  end

  describe "GET /facebook/shops/1/products/2/product_variants/3/edit" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/2/product_variants/3/edit").should_not be_routable }
  end

  describe "PUT /facebook/shops/1/products/2/product_variants/3" do
    specify { put("#{frontoffice_url_root}/facebook/shops/1/products/2/product_variants/3").should_not be_routable }
  end

  describe "DELETE /facebook/shops/1/products/2/product_variants/3" do
    specify { delete("#{frontoffice_url_root}/facebook/shops/1/products/2/product_variants/3").should_not be_routable }
  end

  describe "GET /mobile/shops/1/products/2/product_variants" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/2/product_variants").should_not be_routable }
  end

  describe "GET /mobile/shops/1/products/2/product_variants/new" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/2/product_variants/new").should_not be_routable }
  end

  describe "POST /mobile/shops/1/products/2/product_variants" do
    specify { post("#{frontoffice_url_root}/mobile/shops/1/products/2/product_variants").should_not be_routable }
  end

  describe "GET /mobile/shops/1/products/2/product_variants/3" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/2/product_variants/3").should be_routable }
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/2/product_variants/3").should route_to({controller: "frontoffice/product_variants", action: "show", shop_id: "1", product_id: "2", id: "3", ui: "mobile"}) }
  end

  describe "GET /mobile/shops/1/products/2/product_variants/3/edit" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/2/product_variants/3/edit").should_not be_routable }
  end

  describe "PUT /mobile/shops/1/products/2/product_variants/3" do
    specify { put("#{frontoffice_url_root}/mobile/shops/1/products/2/product_variants/3").should_not be_routable }
  end

  describe "DELETE /mobile/shops/1/products/2/product_variants/3" do
    specify { delete("#{frontoffice_url_root}/mobile/shops/1/products/2/product_variants/3").should_not be_routable }
  end

end
