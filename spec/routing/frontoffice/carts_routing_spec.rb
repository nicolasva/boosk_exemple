require 'spec_helper'    
               
describe Frontoffice::CartsController do

  describe "GET /facebook/shops/1/carts" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/carts").should be_routable }
    specify { get("#{frontoffice_url_root}/facebook/shops/1/carts").should route_to({controller: "frontoffice/carts", action: "index", shop_id: "1", ui: "facebook"}) }
  end

  describe "GET /facebook/shops/1/carts/new" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/carts/new").should_not be_routable }
  end

  describe "POST /facebook/shops/1/carts" do
    specify { post("#{frontoffice_url_root}/facebook/shops/1/carts").should_not be_routable }
  end

  describe "GET /facebook/shops/1/carts/1" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/carts/1").should_not be_routable }
  end

  describe "GET /facebook/shops/1/carts/1/edit" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/carts/1/edit").should_not be_routable }
  end

  describe "PUT /facebook/shops/1/carts/1" do
    specify { put("#{frontoffice_url_root}/facebook/shops/1/carts/1").should_not be_routable }
  end

  describe "DELETE /facebook/shops/1/carts/1" do
    specify { delete("#{frontoffice_url_root}/facebook/shops/1/carts/1").should_not be_routable }
  end

  describe "GET /facebook/shops/1/show_carts" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/show_carts").should be_routable }
    specify { get("#{frontoffice_url_root}/facebook/shops/1/show_carts").should route_to({controller: "frontoffice/carts", action: "show", shop_id: "1", ui: "facebook"}) }
  end

  describe "DELETE /facebook/shops/1/clean_carts" do
    specify { delete("#{frontoffice_url_root}/facebook/shops/1/clean_carts").should be_routable }
    specify { delete("#{frontoffice_url_root}/facebook/shops/1/clean_carts").should route_to({controller: "frontoffice/carts", action: "destroy", shop_id: "1", ui: "facebook"}) }
  end

  describe "GET /mobile/shops/1/carts" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/carts").should be_routable }
    specify { get("#{frontoffice_url_root}/mobile/shops/1/carts").should route_to({controller: "frontoffice/carts", action: "index", shop_id: "1", ui: "mobile"}) }
  end

  describe "GET /mobile/shops/1/carts/new" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/carts/new").should_not be_routable }
  end

  describe "POST /mobile/shops/1/carts" do
    specify { post("#{frontoffice_url_root}/mobile/shops/1/carts").should_not be_routable }
  end

  describe "GET /mobile/shops/1/carts/1" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/carts/1").should_not be_routable }
  end

  describe "GET /mobile/shops/1/carts/1/edit" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/carts/1/edit").should_not be_routable }
  end

  describe "PUT /mobile/shops/1/carts/1" do
    specify { put("#{frontoffice_url_root}/mobile/shops/1/carts/1").should_not be_routable }
  end

  describe "DELETE /mobile/shops/1/carts/1" do
    specify { delete("#{frontoffice_url_root}/mobile/shops/1/carts/1").should_not be_routable }
  end

  describe "GET /mobile/shops/1/show_carts" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/show_carts").should be_routable }
    specify { get("#{frontoffice_url_root}/mobile/shops/1/show_carts").should route_to({controller: "frontoffice/carts", action: "show", shop_id: "1", ui: "mobile"}) }
  end

  describe "DELETE /mobile/shops/1/clean_carts" do
    specify { delete("#{frontoffice_url_root}/mobile/shops/1/clean_carts").should be_routable }
    specify { delete("#{frontoffice_url_root}/mobile/shops/1/clean_carts").should route_to({controller: "frontoffice/carts", action: "destroy", shop_id: "1", ui: "mobile"}) }
  end

end
