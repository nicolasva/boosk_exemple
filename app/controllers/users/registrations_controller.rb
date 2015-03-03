class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :check_funel, :only => [:create]

  private
    def check_funel
      cookies[:have_coupon] = 1 if params[:have_coupon] == "true"
      cookies[:without_cb] = 1 if params[:without_cb] == "true"
    end

end
