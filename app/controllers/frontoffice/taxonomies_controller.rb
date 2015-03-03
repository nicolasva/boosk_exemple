class Frontoffice::TaxonomiesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :set_cookies

  def index
    @taxonomies = Taxonomy.joins(:shop).where('shops.uuid' => params[:shop_id])

    respond_to do |format|
      format.html
      format.json { render json: @taxonomies }
    end 
  end

  def show
    @taxonomy = Taxonomy.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @taxonomy }
    end
  end
end
