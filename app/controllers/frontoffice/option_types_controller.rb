class Frontoffice::OptionTypesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :set_cookies

  def index
    @option_types = OptionType.joins(:shop).where('shops.uuid' => params[:shop_id]).group_by_key

    respond_to do |format|
      format.html
      format.json { render json: @option_types }
    end
  end

  def show
    @option_type = OptionType.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @option_type }
    end
  end
end
