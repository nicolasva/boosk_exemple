require "spec_helper"

describe WizardsController do
  describe "GET /wizards" do
    specify { get("#{backend_url_root}/wizards").should_not be_routable }
  end

  describe "GET /wizard/new" do
    specify { get("#{backend_url_root}/wizard/new").should_not be_routable }
  end

  describe "POST /wizard" do
    specify { post("#{backend_url_root}/wizard").should be_routable }
    specify { post("#{backend_url_root}/wizard").should route_to({:action => "create", :controller => "wizards"}) }
  end

  describe "GET /wizard" do
    specify { get("#{backend_url_root}/wizard").should be_routable }
    specify { get("#{backend_url_root}/wizard").should route_to({:action => "index", :controller => "wizards"}) }
  end

  describe "GET /wizard/edit" do
    specify { get("#{backend_url_root}/shops/1/wizard/edit").should_not be_routable }
  end

  describe "PUT /wizard" do
    specify { put("#{backend_url_root}/shops/1/wizard").should_not be_routable }
  end

  describe "DELETE /wizard" do
    specify { delete("#{backend_url_root}/shops/1/wizard").should_not be_routable }    
  end

  describe "GET /wizard/devises" do
    specify { get("#{backend_url_root}/wizard/devises").should be_routable }
    specify { get("#{backend_url_root}/wizard/devises").should route_to({:action => "devises", :controller => "wizards"}) }
  end
end