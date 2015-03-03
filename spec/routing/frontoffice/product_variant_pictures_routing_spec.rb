require 'spec_helper'

describe Frontoffice::ProductVariantPicturesController do

  describe "GET /facebook/shops/1/products/2/product_variants/3/product_variant_pictures" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/2/product_variants/3/product_variant_pictures").should be_routable }
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/2/product_variants/3/product_variant_pictures").should route_to({controller: "frontoffice/product_variant_pictures", action: "index", shop_id: "1", product_id: "2", product_variant_id: "3", ui: "facebook"}) }
  end

  describe "GET /facebook/shops/1/products/2/product_variants/3/product_variant_pictures/new" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/2/product_variants/3/product_variant_pictures/new").should_not be_routable }
  end

  describe "POST /facebook/shops/1/products/2/product_variants/3/product_variant_pictures" do
    specify { post("#{frontoffice_url_root}/facebook/shops/1/products/2//product_variants/3/product_variant_pictures").should_not be_routable }
  end

  describe "GET /facebook/shops/1/products/2/product_variants/3/product_variant_pictures/4" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/2/product_variants/3/product_variant_pictures/4").should be_routable }
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/2/product_variants/3/product_variant_pictures/4").should route_to({controller: "frontoffice/product_variant_pictures", action: "show", shop_id: "1", product_id: "2", product_variant_id: "3", id: "4", ui: "facebook"}) }
  end

  describe "GET /facebook/shops/1/products/2/product_variants/3/product_variant_pictures/4/edit" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/2/product_variants/3/product_variant_pictures/4/edit").should_not be_routable }
  end

  describe "PUT /facebook/shops/1/products/2/product_variants/3/product_variant_pictures/4" do
    specify { put("#{frontoffice_url_root}/facebook/shops/1/products/2/product_variants/3/product_variant_pictures/4").should_not be_routable }
  end

  describe "DELETE /facebook/shops/1/products/2/product_variants/3/product_variant_pictures/4" do
    specify { delete("#{frontoffice_url_root}/facebook/shops/1/products/2/product_variants/3/product_variant_pictures/4").should_not be_routable }
  end

  describe "GET /mobile/shops/1/products/2/product_variants/3/product_variant_pictures" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/2/product_variants/3/product_variant_pictures").should be_routable }
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/2/product_variants/3/product_variant_pictures").should route_to({controller: "frontoffice/product_variant_pictures", action: "index", shop_id: "1", product_id: "2", product_variant_id: "3", ui: "mobile"}) }
  end

  describe "GET /mobile/shops/1/products/2/product_variants/3/product_variant_pictures/new" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/2/product_variants/3/product_variant_pictures/new").should_not be_routable }
  end

  describe "POST /mobile/shops/1/products/2/product_variants/3/product_variant_pictures" do
    specify { post("#{frontoffice_url_root}/mobile/shops/1/products/2//product_variants/3/product_variant_pictures").should_not be_routable }
  end

  describe "GET /mobile/shops/1/products/2/product_variants/3/product_variant_pictures/4" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/2/product_variants/3/product_variant_pictures/4").should be_routable }
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/2/product_variants/3/product_variant_pictures/4").should route_to({controller: "frontoffice/product_variant_pictures", action: "show", shop_id: "1", product_id: "2", product_variant_id: "3", id: "4", ui: "mobile"}) }
  end

  describe "GET /mobile/shops/1/products/2/product_variants/3/product_variant_pictures/4/edit" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/2/product_variants/3/product_variant_pictures/4/edit").should_not be_routable }
  end

  describe "PUT /mobile/shops/1/products/2/product_variants/3/product_variant_pictures/4" do
    specify { put("#{frontoffice_url_root}/mobile/shops/1/products/2/product_variants/3/product_variant_pictures/4").should_not be_routable }
  end

  describe "DELETE /mobile/shops/1/products/2/product_variants/3/product_variant_pictures/4" do
    specify { delete("#{frontoffice_url_root}/mobile/shops/1/products/2/product_variants/3/product_variant_pictures/4").should_not be_routable }
  end

end
