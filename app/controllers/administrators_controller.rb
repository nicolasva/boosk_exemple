class AdministratorsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_authorization, only: :create

  def index
    @administrators = current_user.invitations

    respond_to do |format|
      format.html
      format.json { render json: @administrators }
    end
  end

  def create
    @administrator = User.invite!(params[:administrator], current_user)

    respond_to do |format|
      format.html
      format.json { render json: @administrator }
    end
  end

  # DELETE /administrators/all
  # DELETE /administrators/all.json
  def destroy_all
    @administrators = current_user.invitations.where("users.id IN (?)", params[:ids]).destroy_all

    respond_to do |format|
      format.json { render json: @administrators }
    end
  end


  private
    def check_authorization
      if (current_user.invitations.count + 1) >= current_user.plan.number_admin.to_i and !current_user.invited_by_id.nil?
        render :text => "You do not have access to this service", :status => :forbidden
      end
    end
end
