class OrdersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_plans
  before_filter :check_shop_authorize

  def index
    @orders = current_user.shops.find_by_uuid(params[:shop_id]).orders.eager_loading.not_unpaid

    respond_to do |format|
      format.html
      format.json { render json: @orders.to_json(:include =>{:contact => {:include => [:addresses,:emails]}, :shop => {}, :line_items => {}}) }
    end
  end

  def show
    @order = Order.eager_loading.find_by_number(params[:id])

    respond_to do |format|
      format.html { render inline: "Not implemented", status: :not_implemented}
      format.json { render json: @order.as_json(:include => {:contact => {:include => [:addresses,:emails]}, :shop => {}, :line_items => {}}) }
    end
  end

  def update
    @order = Order.find_by_number(params[:id])
    @order.change_status(params[:status])

    respond_to do |format|
      format.json{ render :json => @order }
    end
  end

  def update_all
    @orders = current_user.shops.find_by_uuid(params[:shop_id]).orders.where(:id => params[:ids])
    @orders.each do |order|
      order.change_status(params[:status])
    end

    respond_to do |format|
      format.json{ render :json => @orders }
    end
  end
end
