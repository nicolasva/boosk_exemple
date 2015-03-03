require 'spec_helper'

describe Frontoffice::ShopsController do
  describe "GET /facebook/shops" do
    specify { get("#{frontoffice_url_root}/facebook/shops").should_not be_routable }
  end

  describe "GET /facebook/shops/new" do
    specify { get("#{frontoffice_url_root}/facebook/shops/new").should_not be_routable }
  end

  describe "POST /facebook/shops" do
    specify { post("#{frontoffice_url_root}/facebook/shops").should_not be_routable }
  end

  describe "GET /facebook/shops/1" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1").should be_routable }
    specify { get("#{frontoffice_url_root}/facebook/shops/1").should route_to({:controller => "frontoffice/shops", :action => "show", :ui => "facebook", :id => "1"}) }
  end

  describe "GET /facebook/shops/1/edit" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/edit").should_not be_routable }
  end

  describe "PUT /facebook/shops/1" do
    specify { put("#{frontoffice_url_root}/facebook/shops/1").should_not be_routable }
  end

  describe "DELETE /facebook/shops/1" do
    specify { delete("#{frontoffice_url_root}/facebook/shops/1").should_not be_routable }
  end

  describe "GET /translate" do
    specify { get("#{frontoffice_url_root}/translate").should be_routable }
    specify { get("#{frontoffice_url_root}/translate").should route_to({:controller => "frontoffice/shops", :action => "translate"}) }
  end

  describe "GET /geographic_regions" do
    specify { get("#{frontoffice_url_root}/geographic_regions").should be_routable }
    specify { get("#{frontoffice_url_root}/geographic_regions").should route_to({:controller => "frontoffice/shops", :action => "geographic_regions"}) }
  end

  describe "GET /facebook/shops/1/terms_of_services" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/terms_of_services").should be_routable }
    specify { get("#{frontoffice_url_root}/facebook/shops/1/terms_of_services").should route_to({:controller => "frontoffice/shops", :action => "terms_of_services", :ui => "facebook", :shop_id => "1"}) }
  end

  describe "GET /mobile/shops" do
    specify { get("#{frontoffice_url_root}/mobile/shops").should_not be_routable }
  end

  describe "GET /mobile/shops/new" do
    specify { get("#{frontoffice_url_root}/mobile/shops/new").should_not be_routable }
  end

  describe "POST /mobile/shops" do
    specify { post("#{frontoffice_url_root}/mobile/shops").should_not be_routable }
  end

  describe "GET /mobile/shops/1" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1").should be_routable }
    specify { get("#{frontoffice_url_root}/mobile/shops/1").should route_to({:controller => "frontoffice/shops", :action => "show", :ui => "mobile", :id => "1"}) }
  end

  describe "GET /mobile/shops/1/edit" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/edit").should_not be_routable }
  end

  describe "PUT /mobile/shops/1" do
    specify { put("#{frontoffice_url_root}/mobile/shops/1").should_not be_routable }
  end

  describe "DELETE /mobile/shops/1" do
    specify { delete("#{frontoffice_url_root}/mobile/shops/1").should_not be_routable }
  end

  describe "GET /mobile/shops/1/terms_of_services" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/terms_of_services").should be_routable }
    specify { get("#{frontoffice_url_root}/mobile/shops/1/terms_of_services").should route_to({:controller => "frontoffice/shops", :action => "terms_of_services", :ui => "mobile", :shop_id => "1"}) }
  end

  describe "GET /facebook" do
    specify { get("#{frontoffice_url_root}/facebook").should be_routable}
    specify { get("#{frontoffice_url_root}/facebook").should route_to({:controller => "frontoffice/shops", :action => "show", :ui => "facebook"}) }
  end

  describe "GET /mobile" do
    specify { get("#{frontoffice_url_root}/mobile").should be_routable}
    specify { get("#{frontoffice_url_root}/mobile").should route_to({:controller => "frontoffice/shops", :action => "show", :ui => "mobile"}) }
  end
end
