require 'spec_helper'

describe CalculatorTypesController do

  describe "GET /calculator_types" do
    specify { get("#{backend_url_root}/calculator_types").should be_routable }
    specify { get("#{backend_url_root}/calculator_types").should route_to({:controller => "calculator_types", :action => "index"}) }
  end

  describe "GET /calculator_types/new" do
    specify { get("#{backend_url_root}/calculator_types/new").should_not be_routable }
  end

  describe "POST /calculator_types" do
    specify { post("#{backend_url_root}/calculator_types").should_not be_routable }
  end

  describe "GET /calculator_types/1" do
    specify { get("#{backend_url_root}/calculator_types/1").should_not be_routable }
  end

  describe "GET /calculator_types/1/edit" do
    specify { get("#{backend_url_root}/calculator_types/1/edit").should_not be_routable }
  end

  describe "PUT /calculator_types/1" do
    specify { put("#{backend_url_root}/calculator_types/1").should_not be_routable }
  end

  describe "DELETE /calculator_types/1" do
    specify { delete("#{backend_url_root}/calculator_types/1").should_not be_routable }
  end

end