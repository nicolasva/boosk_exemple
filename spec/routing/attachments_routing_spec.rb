require 'spec_helper'

describe AttachmentsController do

  describe "GET /attachments" do
    specify { get("#{backend_url_root}/attachments").should_not be_routable }
  end

  describe "GET /attachments/new" do
    specify { get("#{backend_url_root}/attachments/new").should_not be_routable }
  end

  describe "POST /attachments" do
    specify { post("#{backend_url_root}/attachments").should be_routable }
    specify { post("#{backend_url_root}/attachments").should route_to({:controller => "attachments", :action => "create"}) }
  end

  describe "GET /attachments/1/edit" do
    specify { get("#{backend_url_root}/attachments/1/edit").should_not be_routable }
  end

  describe "PUT /attachments/1" do
    specify { put("#{backend_url_root}/attachments/1").should_not be_routable }
  end

  describe "DELETE /attachments/1" do
    specify { delete("#{backend_url_root}/attachments/1").should_not be_routable }
  end

  describe "GET /attachments/1" do
    specify { get("#{backend_url_root}/attachments/1").should_not be_routable }
  end

end