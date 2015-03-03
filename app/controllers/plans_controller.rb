class PlansController < ApplicationController
  before_filter :authenticate_user!, :except => :ipn_notification
  protect_from_forgery :except => [:ipn_notification]

  layout 'plan'

  def index
    cookies[:u] = current_user.id
    @plans = Plan.all

    respond_to do |format|
      format.html
      format.json { render json: @plans }
    end
  end

  def create
    plan = Plan.find_by_name(params[:plan])
    ppr = PayPal::Recurring.new({
                                  :return_url   => "#{BOOSKETSHOPS['paypal']['plan']['returnUrl']}?plan=#{params[:plan]}",
                                  :cancel_url   => BOOSKETSHOPS['paypal']['plan']['cancelUrl'],
                                  :description  => "TEXT SUSCRIBTION",
                                  :ipn_url      =>  BOOSKETSHOPS['paypal']['plan']['ipnNotificationUrl'],
                                  :amount       =>  plan.monthly_price,
                                  :currency     => "EUR"
                                })

    response = ppr.checkout
    respond_to do |format|
      if response.valid?
        format.json { render json: {paypal_url: response.checkout_url }}
        format.html { redirect_to response.checkout_url }
      else
        format.html { redirect_to dashboard_url, :notice => "Error paypal" }
      end
    end
  end


  def paypal_success_url
    # temp for keyade!
    require 'open-uri'

    plan = Plan.find_by_name(params[:plan])
    ppr = PayPal::Recurring.new({
                                  :token       => params["token"],
                                  :payer_id    => params["PayerID"],
                                  :return_url   => "#{BOOSKETSHOPS['paypal']['plan']['returnUrl']}?plan=#{params[:plan]}",
                                  :cancel_url   => BOOSKETSHOPS['paypal']['plan']['cancelUrl'],
                                  :description  => "TEXT SUSCRIBTION",
                                  :ipn_url      =>  BOOSKETSHOPS['paypal']['plan']['ipnNotificationUrl'] + "?token=#{params[:token]}&payerId=#{params[:PayerID]}&plan=#{plan.name}&cu=#{current_user.id}",
                                  :amount       => plan.monthly_price,
                                  :currency     => "EUR"
                                })

    if ppr.request_payment.approved?
      # temp for keyade!
      if cookies['K_10520']
        if params[:plan] == "1"
          open("http://k.keyade.com/kaev/1/?kaPcId=10520&kaEvId=14821&kaEvMcId=#{params["PayerID"]}&kaClkId=#{cookies['K_10520']}&kaEvCt1=1&kaEvVal1=#{plan.monthly_price}&kaEvSt=confirmed")
        else
          open("http://k.keyade.com/kaev/1/?kaPcId=10520&kaEvId=21560&kaEvMcId=#{params["PayerID"]}&kaClkId=#{cookies['K_10520']}&kaEvCt1=1&kaEvVal1=#{plan.monthly_price}&kaEvSt=confirmed")
        end
      end

      plan = Plan.find_by_name(params[:plan])
      unless current_user.plan_id == plan.id
        current_user.update_attributes(:plan_id => plan.id)
      end

      redirect_to dashboard_url
    else
      redirect_to plans_path
    end
  end


  def ipn_notification
    # temp for keyade!
    require 'open-uri'

    unless params[:plan].nil?
      plan = Plan.find_by_name(params[:plan])
      ppr = PayPal::Recurring.new({
                                    :amount      => plan.monthly_price,
                                    :currency    => "EUR",
                                    :description => "TEXT SUSCRIBTION",
                                    :ipn_url     => BOOSKETSHOPS['paypal']['plan']['ipnNotificationUrl'],
                                    :frequency   => 1,
                                    :token       =>  params["token"],
                                    :period      => :monthly,
                                    :reference   => plan.name,
                                    :payer_id    => params["PayerID"],
                                    :start_at    => Time.now + 1.month,
                                    :failed      => 1,
                                    :outstanding => :next_billing
                                  })

      response = ppr.create_recurring_profile
      user = User.find(params[:cu])
      user.update_attributes(:paypal_account => params[:payer_email],
                              :paypal_uid => response.profile_id)
      if cookies['K_10520']
          open("http://k.keyade.com/kaev/1/?kaPcId=10520&kaEvId=21560&kaEvMcId=#{params["PayerID"]}&kaClkId=#{cookies['K_10520']}&kaEvCt1=1&kaEvVal1=#{plan.monthly_price}&kaEvSt=pending")
      end
    end
    render :nothing => true
  end
end
