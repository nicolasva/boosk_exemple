require 'spec_helper'

describe Frontoffice::TaxonsController do
  describe "GET /facebook/shops/1/taxonomies/2/taxons" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/taxonomies/2/taxons").should be_routable }
    specify { get("#{frontoffice_url_root}/facebook/shops/1/taxonomies/2/taxons").should route_to({controller: "frontoffice/taxons", action: "index", shop_id: "1", taxonomy_id: "2", ui: "facebook"}) }
  end

  describe "GET /facebook/shops/1/taxonomies/2/taxons/new" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/taxonomies/2/taxons/new").should_not be_routable }
  end

  describe "POST /facebook/shops/1/taxonomies/2/taxons" do
    specify { post("#{frontoffice_url_root}/facebook/shops/1/taxonomies/2/taxons").should_not be_routable }
  end

  describe "GET /facebook/shops/1/taxonomies/2/taxons/3" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/taxonomies/2/taxons/3").should be_routable }
    specify { get("#{frontoffice_url_root}/facebook/shops/1/taxonomies/2/taxons/3").should route_to({controller: "frontoffice/taxons", action: "show", shop_id: "1", taxonomy_id: "2", id: "3", ui: "facebook"}) }
  end

  describe "GET /facebook/shops/1/taxonomies/2/taxons/3/edit" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/taxonomies/2/taxons/3/edit").should_not be_routable }
  end

  describe "PUT /facebook/shops/1/taxonomies/2/taxons/3" do
    specify { put("#{frontoffice_url_root}/facebook/shops/1/taxonomies/2/taxons/3").should_not be_routable }
  end

  describe "DELETE /facebook/shops/1/taxonomies/2/taxons/3" do
    specify { delete("#{frontoffice_url_root}/facebook/shops/1/taxonomies/2/taxons/3").should_not be_routable }
  end

  describe "GET /mobile/shops/1/taxonomies/2/taxons" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/taxonomies/2/taxons").should be_routable }
    specify { get("#{frontoffice_url_root}/mobile/shops/1/taxonomies/2/taxons").should route_to({controller: "frontoffice/taxons", action: "index", shop_id: "1", taxonomy_id: "2", ui: "mobile"}) }
  end

  describe "GET /mobile/shops/1/taxonomies/2/taxons/new" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/taxonomies/2/taxons/new").should_not be_routable }
  end

  describe "POST /mobile/shops/1/taxonomies/2/taxons" do
    specify { post("#{frontoffice_url_root}/mobile/shops/1/taxonomies/2/taxons").should_not be_routable }
  end

  describe "GET /mobile/shops/1/taxonomies/2/taxons/3" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/taxonomies/2/taxons/3").should be_routable }
    specify { get("#{frontoffice_url_root}/mobile/shops/1/taxonomies/2/taxons/3").should route_to({controller: "frontoffice/taxons", action: "show", shop_id: "1", taxonomy_id: "2", id: "3", ui: "mobile"}) }
  end

  describe "GET /mobile/shops/1/taxonomies/2/taxons/3/edit" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/taxonomies/2/taxons/3/edit").should_not be_routable }
  end

  describe "PUT /mobile/shops/1/taxonomies/2/taxons/3" do
    specify { put("#{frontoffice_url_root}/mobile/shops/1/taxonomies/1").should_not be_routable }
  end

  describe "DELETE /mobile/shops/1/taxonomies/2/taxons/3" do
    specify { delete("#{frontoffice_url_root}/mobile/shops/1/taxonomies/2/taxons/3").should_not be_routable }
  end
end