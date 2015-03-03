require 'spec_helper'

describe TaxonomiesController do
  before(:each) do
    @user = create(:user, :plan_id => create(:plan))
    @shop = create(:shop, :users => [@user])
    sign_in @user
  end

  describe "#index" do 
    context "when there isn't any taxonomy created" do
      before(:each) do
        Taxonomy.destroy_all
      end

      it "access index page" do
        get :index, :shop_id => @shop.uuid
        response.should be_success
      end

      it "assigns @taxonomies to an empty array" do
        get :index, :shop_id => @shop.uuid
        assigns(:taxonomies).should == []
      end
    end

    context "when there are some taxonomies created" do
      before do
        Taxonomy.destroy_all
        @taxonomies = [create(:taxonomy, :shop => @shop), create(:taxonomy, :shop => @shop)]
        @shop.stub :taxonomies, @taxonomies
      end

      it "access index page" do
        get :index, :shop_id => @shop.uuid
        response.should be_success
      end

      it "assigns @taxonomies to @shop.taxonomies" do
        get :index, :shop_id => @shop.uuid
        assigns(:taxonomies).should == @taxonomies
      end
    end
  end

  describe "#show" do
    before { @taxonomy = create(:taxonomy, :shop_id => @shop.id) }

    it "access page show" do
      get :show, :id => @taxonomy.id, :shop_id => @shop.uuid
      response.should be_success
    end

    it "assigns @taxonomy" do
      get :show, :id => @taxonomy.id, :shop_id => @shop.uuid
      assigns(:taxonomy).should == @taxonomy      
    end
  end 

  describe "#new and #create" do
    before(:each) do
      @taxonomy = build(:taxonomy, :shop_id => @shop.id)
      Taxonomy.stub!(:build).and_return(@taxonomy)
    end

    it "access page new" do
      get :new, :shop_id => @shop.uuid
      response.should be_success 
    end

    it "assigns @taxonomy" do
      get :new, :shop_id => @shop.uuid
      assigns(:taxonomy).should be     
    end

    it "access to create" do
      @params = {:taxonomy => {:name => @taxonomy.name}, :shop_id => @shop.uuid}
      lambda {
        post :create, @params
      }.should change(Taxonomy, :count).by(1) 
    end

    it "redirects after taxonomy creation" do
      @params = {:taxonomy => {:name => @taxonomy.name}, :shop_id => @shop.uuid}
      post :create, @params
      response.should redirect_to shop_taxonomies_path(@shop)
    end

    it "sets flash notice after taxonomy creation" do
      @params = {:taxonomy => {:name => @taxonomy.name}, :shop_id => @shop.uuid}
      post :create, @params
      flash[:notice].should be
    end
  end

  describe "#edit and update" do
    before(:each) do
      @taxonomy = create(:taxonomy, :shop_id => @shop.id)
    end

    it "edit" do
      get :edit, :id => @taxonomy.id, :shop_id => @shop.uuid
      response.should be_success
    end

    it "assigns @taxonomy" do
      get :edit, :id => @taxonomy.id, :shop_id => @shop.uuid
      assigns(:taxonomy).should == @taxonomy
    end

    it "does not change taxonomies count" do
      @params = {:id => @taxonomy.id, :shop_id => @shop.uuid, :name => "#{@taxonomy.name}test"}
      lambda {
        put :update, @params
      }.should_not change(Taxonomy, :count)
    end

    it "redirects after taxonomy edition" do
      @params = {:id => @taxonomy.id, :shop_id => @shop.uuid, :name => "#{@taxonomy.name}test"}
      put :update, @params
      response.should redirect_to shop_taxonomies_path(@shop)
    end

    it "sets flash notice after taxonomy edition" do
      @params = {:id => @taxonomy.id, :shop_id => @shop.uuid, :name => "#{@taxonomy.name}test"}
      put :update, @params
      flash[:notice].should be
    end

  end
  
  describe "#destroy" do
    before { @taxonomy = create(:taxonomy, :shop_id => @shop.id) }
    it { expect { delete :destroy, :format => "js", :id => @taxonomy.id, :shop_id => @shop.uuid }.to change{ Taxonomy.count }.by(-1) }
  end

end
