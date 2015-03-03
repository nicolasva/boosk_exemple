require 'spec_helper'

describe PromotionsController do
  before(:each) do
    @user = create(:user, :plan_id => create(:plan))
    @shop = create(:shop, :users => [@user])
    sign_in @user
  end

  describe "#index" do
    context "when there is not any promotion created" do

      it "accesses to the index page" do
        get :index, :shop_id => @shop.uuid
        response.should be_success
      end

      it "assigns @promotions with an empty array" do
        get :index, :shop_id => @shop.uuid
        assigns(:promotions).should be_empty        
      end
    end

    context "when there are created promotions" do
      before(:each) do
        @promotions = [create(:promotion, :shop => @shop), create(:promotion, :shop => @shop)]
        @shop.stub :promotions, @promotions
      end

      it "accesses the index page" do
        get :index, :shop_id => @shop.uuid
        response.should be_success
      end

      it "assigns @promotions with @shop promotions" do
        get :index, :shop_id => @shop.uuid
        assigns(:promotions).should == @promotions
      end
    end
  end

  describe "#show" do
    before { @promotion = create(:promotion, :shop => @shop) }

    it "access page show" do
      get :show, :id => @promotion, :shop_id => @shop.uuid
      response.should be_success
    end

    it "assigns @promotion" do
      get :show, :id => @promotion, :shop_id => @shop.uuid
      assigns(:promotion).should == @promotion
    end
  end

  describe "#new and #create" do
    before(:each) do
      @promotion = build(:promotion, :shop => @shop)
      Promotion.stub!(:build).and_return(@promotion)
    end

    it "accesses page new" do
      get :new, :shop_id => @shop.uuid
      response.should be_success 
    end

    it "assigns @promotion" do
      get :new, :shop_id => @shop.uuid
      assigns(:promotion).should be
    end

    it "access to create" do
      @params = {:promotion => attributes_for(:promotion, shop: @shop), :shop_id => @shop.uuid}
      lambda {
        post :create, @params
      }.should change(Promotion, :count).by(1) 
    end

    it "redirects after promotion creation" do
      @params = {:promotion => attributes_for(:promotion, shop: @shop), :shop_id => @shop.uuid}
      post :create, @params
      response.should redirect_to shop_promotions_path(@shop)
    end

    it "sets flash notice after promotion creation" do
      @params = {:promotion => attributes_for(:promotion, shop: @shop), :shop_id => @shop.uuid}
      post :create, @params
      flash[:notice].should be
    end
  end

  describe "#edit and update" do
    before(:each) do
      @promotion = create(:promotion, :shop => @shop)
    end

    it "edit" do
      get :edit, :id => @promotion, :shop_id => @shop.uuid
      response.should be_success
    end

    it "assigns @promotion" do
      get :edit, :id => @promotion, :shop_id => @shop.uuid
      assigns(:promotion).should == @promotion
    end

    it "does not change promotions count" do
      @params = {:id => @promotion, :shop_id => @shop.uuid, :promotion => {:name => "#{@promotion.name}test"} }
      lambda {
        put :update, @params
      }.should_not change(Promotion, :count)
    end

    it "redirects after promotion edition" do
      @params = {:id => @promotion, :shop_id => @shop.uuid, :promotion => {:name => "#{@promotion.name}test"} }
      put :update, @params
      response.should redirect_to shop_promotions_path(@shop)
    end

    it "sets flash notice after promotion edition" do
      @params = {:id => @promotion, :shop_id => @shop.uuid, :promotion => {:name => "#{@promotion.name}test"} }
      put :update, @params
      flash[:notice].should be
    end
  end
  
  describe "#destroy" do
    before { @promotion = create(:promotion, :shop => @shop) }
    it { expect { delete :destroy, :format => "js", :id => @promotion, :shop_id => @shop.uuid }.to change{ Promotion.count }.by(-1) }
  end
end