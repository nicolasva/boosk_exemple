require 'spec_helper'

describe TrackersController do

  describe "GET /trackers" do
    specify { get("/trackers").should_not be_routable }
  end

  describe "GET /trackers/new" do
    specify { get("/trackers/new").should_not be_routable }
  end

  describe "POST /trackers" do
    specify { post("/trackers").should be_routable }
    specify { post("/trackers").should route_to({:controller => "trackers", :action => "create"}) }
  end

  describe "GET /trackers/1/edit" do
    specify { get("/trackers/1/edit").should_not be_routable }
  end

  describe "PUT /trackers/1" do
    specify { put("/trackers/1").should_not be_routable }
  end

  describe "DELETE /trackers/1" do
    specify { delete("/trackers/1").should_not be_routable }
  end

  describe "GET /trackers/1" do
    specify { get("/trackers/1").should_not be_routable }
  end

end