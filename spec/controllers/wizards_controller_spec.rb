require 'spec_helper'

describe WizardsController do
  before(:each) do
    @user = create(:user, :plan_id => create(:plan))
    sign_in @user
  end

  describe "#index" do
    it "access page" do
      get :index

      response.should be_success 
    end
  end

  describe '#devises' do
    it 'should be render devises' do
      get :devises, :format => :json

      DEVISES.should_not be_nil
      response.should be_success 
    end
  end

end
