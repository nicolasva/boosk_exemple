class Dash::OrdersController < ApplicationController
  skip_before_filter :set_cookies, :set_locale
  skip_after_filter  :set_cookies, :set_access_control_headers, :set_p3p

  def index
    @orders = Order.where(:workflow_state => :paid).includes(:shop)

    render json: @orders.as_json(:include => [:shop => { :only => :devise }])
  end

end


