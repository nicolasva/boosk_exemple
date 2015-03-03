class WizardsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_plans
  before_filter :check_authorization, :except => [:devises]

  layout 'wizard'

  def index
    # temp for keyade!
    cookies[:u] = current_user.id

    respond_to do |format|
      format.html
      format.json
    end
  end

  def devises

    respond_to do |format|
      format.html
      format.json { render json: DEVISES}
    end
  end

  private
    def check_authorization
      if current_user.shops.count >= current_user.plan.number_f_shop
        render :text => "You do not have access to this service", :status => :forbidden
      end
    end
end
