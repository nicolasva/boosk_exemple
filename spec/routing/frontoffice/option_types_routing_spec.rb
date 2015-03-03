require 'spec_helper'

describe Frontoffice::OptionTypesController do

  describe "GET /facebook/shops/1/option_types/4" do
    specify { get("#{frontoffice_url_root}/facebook/shops/1/option_types/4").should be_routable }
  end

  describe "GET /facebook/shops/1/option_types" do
    specify { put("#{frontoffice_url_root}/facebook/shops/1/products/2/product_variants/3/option_types/4").should_not be_routable }
  end

  describe "DELETE /facebook/shops/1/option_types/4" do
    specify { delete("#{frontoffice_url_root}/facebook/shops/1/option_types/4").should_not be_routable }
  end

  describe "PUT /facebook/shops/1/option_types/4" do
    specify { delete("#{frontoffice_url_root}/facebook/shops/1/option_types/4").should_not be_routable }
  end

  describe "POST /facebook/shops/1/option_types" do
    specify { delete("#{frontoffice_url_root}/facebook/shops/1/option_types").should_not be_routable }
  end

  describe "GET /mobile/shops/1/option_types/4" do
    specify { get("#{frontoffice_url_root}/mobile/shops/1/option_types/4").should be_routable }
  end

  describe "GET /mobile/shops/1/option_types" do
    specify { put("#{frontoffice_url_root}/mobile/shops/1/products/2/product_variants/3/option_types/4").should_not be_routable }
  end

  describe "DELETE /mobile/shops/1/option_types/4" do
    specify { delete("#{frontoffice_url_root}/mobile/shops/1/option_types/4").should_not be_routable }
  end

  describe "PUT /mobile/shops/1/option_types/4" do
    specify { delete("#{frontoffice_url_root}/mobile/shops/1/option_types/4").should_not be_routable }
  end

  describe "POST /mobile/shops/1/option_types" do
    specify { delete("#{frontoffice_url_root}/mobile/shops/1/option_types").should_not be_routable }
  end

end
