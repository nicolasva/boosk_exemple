class Frontoffice::TaxonsController < ApplicationController 
  skip_before_filter :verify_authenticity_token, :set_cookies

  def index
    @taxons = Taxonomy.find(params[:taxonomy_id]).taxons

    respond_to do |format|
      format.html
      format.json { render json: @taxons }
    end
  end

  def show
    @taxon = Taxonomy.find(params[:taxonomy_id]).taxons.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @taxon }
    end
  end
end
