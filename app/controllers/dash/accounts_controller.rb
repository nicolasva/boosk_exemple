class Dash::AccountsController < ApplicationController
  skip_before_filter :set_cookies, :set_locale
  skip_after_filter  :set_cookies, :set_access_control_headers, :set_p3p

  def index
    @accounts = User.all

    render json: @accounts.as_json(:include => [:address, :plan, :subscription] )
  end

end

