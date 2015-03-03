class Dash::ProductsController < ApplicationController
  skip_before_filter :set_cookies, :set_locale
  skip_after_filter  :set_cookies, :set_access_control_headers, :set_p3p

  def index
    @products = Product.all

    render json: @products.as_json
  end

end

