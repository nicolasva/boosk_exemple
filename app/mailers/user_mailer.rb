class UserMailer < ActionMailer::Base
  default from: "welcome@boosket.com"

  def invit_step_create_account(user)
    @user = user
    mail(to: "contact@boosket.com" , subject: "Invit step create account")
  end 

  def invit_step_create_shop(user, shop)
    @user = user
    @shop = shop
    mail(to: "contact@boosket.com" , subject: "Invit step create shop")
  end

  def confirmation_instructions(user)
    @user = user
    attachments.inline['boosket-shop.png'] = File.read("#{Rails.root}/app/assets/images/boosket-shop.png")
    mail(to: user.email , subject: "Boosket Shop - #{t("mailer.users.confirmation_instructions.h1")}")
  end

  def finalize_subscription(user)
    @user = user
    attachments.inline['boosket-shop.png'] = File.read("#{Rails.root}/app/assets/images/boosket-shop.png")
    mail(to: user.email , subject: "Boosket Shop - #{t("mailer.users.finalize_subscription.h1")}")
  end

  def unsuscribe(user)
    @user = user
    attachments.inline['boosket-shop.png'] = File.read("#{Rails.root}/app/assets/images/boosket-shop.png")
    mail(to: user.email, subject: "Boosket Shop - #{t("mailer.users.unsuscribe.h1")}")
  end

end
