class User < ActiveRecord::Base
  belongs_to                :plan
  has_one                   :subscription,                                            :dependent => :destroy
  has_and_belongs_to_many   :shops
  has_one                   :address,                            :as => :addressable, :dependent => :destroy
  has_many                  :invitations, :class_name => 'User', :as => :invited_by,  :dependent => :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, :rememberable,
         :token_authenticatable, :encryptable, :lockable, :timeoutable,
         :omniauthable, :invitable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :paypal_account, :facebook_uid, :facebook_token
  attr_accessible :id, :plan_id, :paypal_uid, :provider, :uid
  attr_accessible :company, :siret
  attr_accessible :firstname, :lastname, :phone_number, :address_attributes, :shop_key, :unsuscribe, :funel_type, :created_at

  attr_accessor :have_coupon, :without_cb

  accepts_nested_attributes_for :address, :allow_destroy => true

  after_invitation_accepted :affect_rights

  def self.master
    where(:invited_by_id => nil).first
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                         provider:auth.provider,
                         uid:auth.uid,
                         email:auth.info.email,
                         firstname:auth.info.first_name,
                         lastname:auth.info.last_name,
                         password:Devise.friendly_token[0,20]
                        )
    end
    user
  end

  def is_master
    self.invited_by_id.nil?
  end

  def affect_rights
    parent_user = User.find(self.invited_by_id)
    self.plan_id = parent_user.plan_id
    self.shops << parent_user.shops
    self.save!
  end

end
