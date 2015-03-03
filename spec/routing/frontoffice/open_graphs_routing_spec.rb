require 'spec_helper'

describe Frontoffice::OpenGraphsController do

  describe "GET /facebook/shops/1/products/2/open_graphs" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/2/open_graphs").should_not be_routable }
  end

  describe "GET /facebook/shops/1/products/2/open_graphs/new" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/2/open_graphs/new").should_not be_routable }
  end

  describe "POST /facebook/shops/1/products/2/open_graphs" do
    specify { post("#{frontoffice_url_root}/facebook/shops/1/products/2/open_graphs").should be_routable }
    specify { post("#{frontoffice_url_root}/facebook/shops/1/products/2/open_graphs").should route_to({controller: "frontoffice/open_graphs", action: "create", shop_id: "1", product_id: "2", ui: "facebook"}) }
  end

  describe "GET /facebook/shops/1/products/2/open_graphs/3" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/2/open_graphs/3").should_not be_routable }
  end

  describe "GET /facebook/shops/1/products/2/open_graphs/3/edit" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/products/2/open_graphs/3/edit").should_not be_routable }
  end

  describe "PUT /facebook/shops/1/products/2/open_graphs/3" do
    specify { put("#{frontoffice_url_root}/facebook/shops/1/products/2/open_graphs/3").should_not be_routable }
  end

  describe "DELETE /facebook/shops/1/products/2/open_graphs/3" do
    specify { delete("#{frontoffice_url_root}/facebook/shops/1/products/2/open_graphs/3").should_not be_routable }
  end

  describe "GET /mobile/shops/1/products/2/open_graphs" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/2/open_graphs").should_not be_routable }
  end

  describe "GET /mobile/shops/1/products/2/open_graphs/new" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/2/open_graphs/new").should_not be_routable }
  end

  describe "POST /mobile/shops/1/products/2/open_graphs" do
    specify { post("#{frontoffice_url_root}/mobile/shops/1/products/2/open_graphs").should be_routable }
    specify { post("#{frontoffice_url_root}/mobile/shops/1/products/2/open_graphs").should route_to({controller: "frontoffice/open_graphs", action: "create", shop_id: "1", product_id: "2", ui: "mobile"}) }
  end

  describe "GET /mobile/shops/1/products/2/open_graphs/3" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/2/open_graphs/3").should_not be_routable }
  end

  describe "GET /mobile/shops/1/products/2/open_graphs/3/edit" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/products/2/open_graphs/3/edit").should_not be_routable }
  end

  describe "PUT /mobile/shops/1/products/2/open_graphs/3" do
    specify { put("#{frontoffice_url_root}/mobile/shops/1/products/2/open_graphs/3").should_not be_routable }
  end

  describe "DELETE /mobile/shops/1/products/2/open_graphs/3" do
    specify { delete("#{frontoffice_url_root}/mobile/shops/1/products/2/open_graphs/3").should_not be_routable }
  end

end