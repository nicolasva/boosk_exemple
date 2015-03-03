require 'spec_helper'

describe Frontoffice::ProductsController do

  describe "GET /facebook/shops/1/products" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products").should_not be_routable }
  end

  describe "GET /facebook/shops/1/products/new" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/new").should_not be_routable }
  end

  describe "POST /facebook/shops/1/products" do
    specify { post("#{frontoffice_url_root}/facebook/shops/1/products").should_not be_routable }
  end

  describe "GET /facebook/shops/1/products/1" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/1").should be_routable }
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/1").should route_to({controller: "frontoffice/products", action: "show", shop_id: "1", id: "1", ui: "facebook"}) }
  end

  describe "GET /facebook/shops/1/products/1/edit" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/1/edit").should_not be_routable }
  end

  describe "PUT /facebook/shops/1/products/1" do
    specify { put("#{frontoffice_url_root}/facebook/shops/1/products/1").should_not be_routable }
  end

  describe "DELETE /facebook/shops/1/products/1" do
    specify { delete("#{frontoffice_url_root}/facebook/shops/1/products/1").should_not be_routable }
  end

  describe "GET /facebook/shops/1/products/index/:query" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/index/azerty").should be_routable }
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/index/azerty").should route_to({controller: "frontoffice/products", action: "index", shop_id: "1", query: "azerty", ui: "facebook"}) }
  end

  describe "GET /mobile/shops/1/products" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products").should_not be_routable }
  end

  describe "GET /mobile/shops/1/products/new" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/new").should_not be_routable }
  end

  describe "POST /mobile/shops/1/products" do
    specify { post("#{frontoffice_url_root}/mobile/shops/1/products").should_not be_routable }
  end

  describe "GET /mobile/shops/1/products/1" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/1").should be_routable }
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/1").should route_to({controller: "frontoffice/products", action: "show", shop_id: "1", id: "1", ui: "mobile"}) }
  end

  describe "GET /mobile/shops/1/products/1/edit" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/1/edit").should_not be_routable }
  end

  describe "PUT /mobile/shops/1/products/1" do
    specify { put("#{frontoffice_url_root}/mobile/shops/1/products/1").should_not be_routable }
  end

  describe "DELETE /mobile/shops/1/products/1" do
    specify { delete("#{frontoffice_url_root}/mobile/shops/1/products/1").should_not be_routable }
  end

  describe "GET /mobile/shops/1/products/index/:query" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/index/azerty").should be_routable }
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/index/azerty").should route_to({controller: "frontoffice/products", action: "index", shop_id: "1", query: "azerty", ui: "mobile"}) }
  end
end
