class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :check_unsuscribe, :only => [:facebook]

  def facebook
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_session_url
    end
  end

  private
    def check_unsuscribe
      @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
      redirect_to new_user_session_url if @user.unsuscribe
    end
end
