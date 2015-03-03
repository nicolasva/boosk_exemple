require 'spec_helper'

describe DashboardsController do

  context '#show' do

    describe "#show with no plan and no shops" do
      it "should redirect to plans_path" do
        @user = create(:user, :plan_id => nil)
        sign_in @user
        get :show
        response.should redirect_to(plans_path)
      end
    end

    describe "#show with plan and no shops" do
      it "should redirect to wizard_path" do
        @user = create(:user, :plan_id => create(:plan))
        sign_in @user
        get :show
        response.should redirect_to(wizards_path)
      end
    end

    describe "#show with plan and shops" do
      it "should render show" do
        @user = create(:user, :plan_id => create(:plan))
        @shop = create(:shop, :users => [@user])

        sign_in @user
        get :show
        response.should be_success
      end
    end
  end
  
  context 'dashboard collection' do
    before(:each) do
      @user = create(:user, :plan_id => create(:plan))
      @shop = create(:shop, :users  => [@user])
      sign_in @user
    end

    describe "#shop_functionnality" do
      it "should be render shop functionnality" do
        cookies[:shop_id] = @shop.uuid
        get :shop_functionnality, :format => :json

        response.should be_success
      end
    end

    describe "#general_analytics" do
      it "should be render general_analytics" do
        cookies[:shop_id] = @shop.uuid
        get :shop_functionnality, :format => :json

        response.should be_success
      end
    end

    describe "#geographic_regions" do
      it "should be render geographic_regions" do
        get :geographic_regions, :format => :json

        response.should be_success
      end
    end

    describe "#translate" do
      it "should be render translates" do
        get :translate, :format => :json

        response.should be_success
      end
    end

    describe "#update" do
      it "update" do
        proc{
          put :update, :format => "js"
        }
        response.status.should == 200
      end
    end
  end
end
