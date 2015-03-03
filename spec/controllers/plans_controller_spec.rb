require 'spec_helper'

describe PlansController do
  before(:each) do
    @user = create(:user, :plan_id => nil)
    sign_in @user
  end

  describe "#index" do
    it "access page" do
      @plans = create_list(:plan, 4)
      get :index
      plans = assigns(:plans)
      response.should be_success
    end
  end
end
