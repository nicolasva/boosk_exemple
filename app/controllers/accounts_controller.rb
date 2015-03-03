class AccountsController < ApplicationController
  require 'rest-graph'

  # GET /account
  # GET /account.json
  def show
    @user = current_user

    respond_to do |format|
      format.json { render json: @user.as_json(:include => [:address,:plan]) }
    end
  end

  # PUT /account
  # PUT /account.json
  def update
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        # Sign in the user bypassing validation in case his password changed
        sign_in @user, :bypass => true
        format.html { redirect_to root_path }
        format.json { render json: @user }
      else
        format.html { render "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    UserMailer.unsuscribe(current_user).deliver
    AdminMailer.unsuscribe(current_user, params[:reason]).deliver
    r = Guid.new
    current_user.update_attributes(:unsuscribe => true)
    current_user.reset_password!(r, r)

    if current_user.is_master
      Shop.by_user(current_user.id).update_all "facebook_status=false,mobile_status=false,google_shopping_status=false,web_status=false,tv_status=false"
      rg = RestGraph.new
      current_user.shops.each do |shop|
        unless shop.fan_page_id.nil? and fan_page_id.blank?
          rg.access_token = shop.facebook_page_token
          rg.delete("#{shop.fan_page_id}/tabs/app_#{BOOSKETSHOPS['facebook']['app_id']}",:async => true)
        end
      end
      # temp for keyade!
      require 'open-uri'
      open("http://k.keyade.com/kast/1/?kaPcId=10520&kaEvId=62927&kaEvMcId=#{current_user.id}&kaEvSt=cancelled")
    end


    sign_out current_user

    respond_to do |format|
      format.html { redirect_to new_user_session_path }
      format.json { render json: current_user.to_json }
    end
  end

end
