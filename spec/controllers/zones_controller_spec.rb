require 'spec_helper'

describe ZonesController do
  before(:each) do
    @user = create(:user, :plan_id => create(:plan))
    @shop = create(:shop, :users => [@user])
    sign_in @user
  end

  describe "#index" do 
    context "when there isn't any zone created" do
      it "access index page" do
        get :index, :shop_id => @shop.uuid
        response.should be_success
      end

      it "assigns @zones to an empty array" do
        get :index, :shop_id => @shop.uuid
        assigns(:zones).should == []
      end
    end

    context "when there are some zones created" do
      before do
        @zones = [create(:zone, :shop => @shop), create(:zone, :shop => @shop)]
        @shop.stub :zones, @zones
      end

      it "access index page" do
        get :index, :shop_id => @shop.uuid
        response.should be_success
      end

      it "assigns @zones to @shop.zones" do
        get :index, :shop_id => @shop.uuid
        assigns(:zones).should == @zones
      end
    end
  end

  describe "#show" do
    before { @zone = create(:zone, :shop_id => @shop.id) }

    it "access page show" do
      get :show, :id => @zone.id, :shop_id => @shop.uuid
      response.should be_success
    end

    it "assigns @zone" do
      get :show, :id => @zone.id, :shop_id => @shop.uuid
      assigns(:zone).should == @zone      
    end
  end 

  describe "#new and #create" do
    before(:each) do
      @zone = build(:zone, :shop_id => @shop.id)
      Zone.stub!(:build).and_return(@zone)
    end

    it "access page new" do
      get :new, :shop_id => @shop.uuid
      response.should be_success 
    end

    it "assigns @zone" do
      get :new, :shop_id => @shop.uuid
      assigns(:zone).should be     
    end

    it "access to create" do
      @params = {:zone => {:name => @zone.name}, :shop_id => @shop.uuid}
      lambda {
        post :create, @params
      }.should change(Zone, :count).by(1) 
    end

    it "redirects after zone creation" do
      @params = {:zone => {:name => @zone.name}, :shop_id => @shop.uuid}
      post :create, @params
      response.should redirect_to shop_zones_path(@shop)
    end

    it "sets flash notice after zone creation" do
      @params = {:zone => {:name => @zone.name}, :shop_id => @shop.uuid}
      post :create, @params
      flash[:notice].should be
    end
  end

  describe "#edit and update" do
    before(:each) do
      @zone = create(:zone, :shop_id => @shop.id)
    end

    it "edit" do
      get :edit, :id => @zone.id, :shop_id => @shop.uuid
      response.should be_success
    end

    it "assigns @zone" do
      get :edit, :id => @zone.id, :shop_id => @shop.uuid
      assigns(:zone).should == @zone
    end

    it "does not change zones count" do
      @params = {:id => @zone.id, :shop_id => @shop.uuid, :name => "#{@zone.name}test"}
      lambda {
        put :update, @params
      }.should_not change(Zone, :count)
    end

    it "redirects after zone edition" do
      @params = {:id => @zone.id, :shop_id => @shop.uuid, :name => "#{@zone.name}test"}
      put :update, @params
      response.should redirect_to shop_zones_path(@shop)
    end

    it "sets flash notice after zone edition" do
      @params = {:id => @zone.id, :shop_id => @shop.uuid, :name => "#{@zone.name}test"}
      put :update, @params
      flash[:notice].should be
    end

  end
  
  describe "#destroy" do
    before { @zone = create(:zone, :shop_id => @shop.id) }
    it { expect { delete :destroy, :format => "js", :id => @zone.id, :shop_id => @shop.uuid }.to change{ Zone.count }.by(-1) }
  end

end
