class SubscriptionsController < ApplicationController
  layout 'plan'
  before_filter :authenticate_user!
  before_filter :check_funel, :only => [:new, :edit]

  def new
    @plan = Plan.find_by_name(params[:plan]) if params[:plan]
    @period = params[:period] || "month"
    @subscription = Subscription.new

    respond_to do |format|
      format.html
    end
  end

  def create
     exist = !current_user.subscription.nil?
     save_trial = current_user.subscription.trial_period if exist
     @subscription = current_user.build_subscription(params[:subscription])
     @subscription.month = params[:date][:month]
     @subscription.year = params[:date][:year]
     @subscription.alias = current_user.email
     @subscription.exist = exist
     @subscription.save_trial = save_trial if exist

    if @subscription.save and @subscription.process
      current_user.update_attributes(plan_id: @subscription.plan.id, :funel_type => 1)

      # temp for keyade!
      require 'open-uri'
      if cookies['K_10520']
        if current_user.plan.name == "start"
          open("http://k.keyade.com/kaev/1/?kaPcId=10520&kaEvId=14821&kaEvMcId=#{current_user.id}&kaClkId=#{cookies['K_10520']}&kaEvCt1=1&kaEvVal1=#{current_user.plan.monthly_price}&kaEvSt=confirmed")
        else
          open("http://k.keyade.com/kaev/1/?kaPcId=10520&kaEvId=21560&kaEvMcId=#{current_user.id}&kaClkId=#{cookies['K_10520']}&kaEvCt1=1&kaEvVal1=#{current_user.plan.monthly_price}&kaEvSt=confirmed")
        end
        open("http://k.keyade.com/kaev/1/?kaPcId=10520&kaEvId=62927&kaEvMcId=#{current_user.id}&kaClkId=#{cookies['K_10520']}&kaEvCt1=1&kaEvVal1=#{current_user.plan.monthly_price}&kaEvSt=pending")
      end
      redirect_to "/"
    else
      @subscription.destroy
      @plan = Plan.find(params[:subscription][:plan_id])
      @period = params[:subscription][:period]
      render :action => :new
    end
  end

  def edit
    @plan = Plan.find_by_name(params[:plan]) if params[:plan]
    @period = params[:period] || "month"
    @subscription = Subscription.new

    respond_to do |format|
      format.html
    end
  end

  def update
    exist = !current_user.subscription.nil?
    save_trial = current_user.subscription.trial_period if exist
    @subscription = current_user.build_subscription(params[:subscription])
    @subscription.month = params[:date][:month]
    @subscription.year = params[:date][:year]
    @subscription.alias = current_user.email
    @subscription.exist = exist
    @subscription.save_trial = save_trial if exist

    if @subscription.save and @subscription.process
      current_user.update_attributes(plan_id: @subscription.plan.id)
      AdminMailer.account_upgraded(current_user).deliver
      redirect_to "/"
    else
      @subscription.destroy
      @plan = Plan.find(params[:subscription][:plan_id])
      @period = params[:subscription][:period]
      render :action => :edit
    end
  end

  private
    def check_funel
      if cookies[:have_coupon]
        coupon = Coupon.find params[:coupon]
        unless coupon.empty?
          current_user.update_attributes(:plan_id => Plan.find_by_name('premium').id, :funel_type => 2)
          Coupon.destroy params[:coupon]
          cookies.delete :have_coupon
          redirect_to "/"
        end
      elsif cookies[:without_cb]
        current_user.update_attributes(:plan_id => Plan.find_by_name(params[:plan]).id, :funel_type => 3)
        cookies.delete :without_cb
        redirect_to "/"
      elsif params[:plan] == "start"
        current_user.update_attributes(:plan_id => Plan.find_by_name("start").id, :funel_type => 3)
        redirect_to "/"
      end
      redirect_to "/" unless current_user.invited_by_id.nil?
    end
end
