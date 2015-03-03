class Dash::ShopsController < ApplicationController
  skip_before_filter :set_cookies, :set_locale
  skip_after_filter  :set_cookies, :set_access_control_headers, :set_p3p

  def index
    @shops = Shop.all

    render json: @shops.as_json(:include => {:contact => {:include => [:addresses]}})
  end

end
