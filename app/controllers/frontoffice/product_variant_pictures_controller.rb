class Frontoffice::ProductVariantPicturesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :set_cookies

  def index
    @productvariantpictures = ProductVariant.find(params[:product_variant_id]).pictures

    respond_to do |format|
      format.html
      format.json { render json: @productvariantpictures }
    end
  end

  def show
    @productvariantpicture = ProductVariantPicture.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @productvariantpicture }
    end
  end
end
