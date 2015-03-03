require 'spec_helper'

describe TaxonsController do
  before(:each) do
    @user = create(:user, :plan_id => create(:plan))
    @shop = create(:shop, :users => [@user])
    @taxonomy= create(:taxonomy, :shop => @shop)
    sign_in @user
  end

  describe "#index" do 
    context "when there isn't any taxon created" do
      before(:each) do
        @taxonomy.taxons.destroy_all
      end

      it "access index page" do
        get :index, :shop_id => @shop.uuid, :taxonomy_id => @taxonomy.id
        response.should be_success
      end

      it "assigns @taxons to an empty array" do
        get :index, :shop_id => @shop.uuid, :taxonomy_id => @taxonomy.id
        assigns(:taxons).should == []
      end
    end

    context "when there are some taxons created" do
      before do
        @taxons = [@taxonomy.root, create(:taxon, :taxonomy => @taxonomy), create(:taxon, :taxonomy => @taxonomy)]
        @taxonomy.stub :taxons, @taxons
      end

      it "access index page" do
        get :index, :shop_id => @shop.uuid, :taxonomy_id => @taxonomy.id
        response.should be_success
      end

      it "assigns @taxons to @taxonomy.taxons" do
        get :index, :shop_id => @shop.uuid, :taxonomy_id => @taxonomy.id
        assigns(:taxons).should == @taxons
      end
    end
  end

  describe "#show" do
    before { @taxon = create(:taxon, :taxonomy => @taxonomy) }

    it "access page show" do
      get :show, :id => @taxon.id, :shop_id => @shop.uuid, :taxonomy_id => @taxonomy.id
      response.should be_success
    end

    it "assigns @taxon" do
      get :show, :id => @taxon.id, :shop_id => @shop.uuid, :taxonomy_id => @taxonomy.id
      assigns(:taxon).should == @taxon      
    end
  end 

  describe "#new and #create" do
    before(:each) do
      @taxon = build(:taxon, :taxonomy => @taxonomy)
      Taxon.stub!(:build).and_return(@taxon)
    end

    it "access page new" do
      get :new, :shop_id => @shop.uuid, :taxonomy_id => @taxonomy.id
      response.should be_success 
    end

    it "assigns @taxon" do
      get :new, :shop_id => @shop.uuid, :taxonomy_id => @taxonomy.id
      assigns(:taxon).should be     
    end

    it "access to create" do
      @params = {:taxon => {:name => @taxonomy.name, :position => 1}, :shop_id => @shop.uuid, :taxonomy_id => @taxonomy.id }
      lambda {
        post :create, @params
      }.should change(Taxon, :count).by(1) 
    end

    it "redirects after taxon creation" do
      @params = {:taxon => {:name => @taxonomy.name, :position => 1}, :shop_id => @shop.uuid, :taxonomy_id => @taxonomy.id }
      post :create, @params
      response.should redirect_to shop_taxonomy_taxons_path(@shop, @taxonomy)
    end

    it "sets flash notice after taxon creation" do
      @params = {:taxon => {:name => @taxonomy.name, :position => 1}, :shop_id => @shop.uuid, :taxonomy_id => @taxonomy.id }
      post :create, @params
      flash[:notice].should be
    end
  end

  describe "#edit and update" do
    before(:each) do
      @taxon = create(:taxon, :taxonomy => @taxonomy)
    end

    it "edit" do
      get :edit, :id => @taxon.id, :shop_id => @shop.uuid, :taxonomy_id => @taxonomy.id
      response.should be_success
    end

    it "assigns @taxon" do
      get :edit, :id => @taxon.id, :shop_id => @shop.uuid, :taxonomy_id => @taxonomy.id
      assigns(:taxon).should == @taxon
    end

    it "does not change taxons count" do
      @params = {:id => @taxon.id, :shop_id => @shop.uuid, :taxonomy_id => @taxonomy.id, :name => "#{@taxonomy.name}test"}
      lambda {
        put :update, @params
      }.should_not change(Taxon, :count)
    end

    it "redirects after taxon edition" do
      @params = {:id => @taxon.id, :shop_id => @shop.uuid, :taxonomy_id => @taxonomy.id, :name => "#{@taxonomy.name}test"}
      put :update, @params
      response.should redirect_to shop_taxonomy_taxons_path(@shop, @taxonomy)
    end

    it "sets flash notice after taxonomy edition" do
      @params = {:id => @taxon.id, :shop_id => @shop.uuid, :taxonomy_id => @taxonomy.id, :name => "#{@taxonomy.name}test"}
      put :update, @params
      flash[:notice].should be
    end

  end
  
  describe "#destroy" do
    before { @taxon = create(:taxon, :taxonomy => @taxonomy) }
    it { expect { delete :destroy, :format => "js", :id => @taxon.id, :shop_id => @shop.uuid, :taxonomy_id => @taxonomy.id }.to change{ Taxon.count }.by(-1) }
  end

end
