class Frontoffice::ProductVariantsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :set_cookies

  def show
    @product_variant = ProductVariant.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @product_variant.to_json(:include => {:product => {:include => {:shop => {:include => :customization}}}, :option_types => {}, :pictures => {}}) }
    end
  end
end
