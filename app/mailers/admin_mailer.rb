class AdminMailer < ActionMailer::Base
  default from: "no-reply@boosket.com"

  def account_upgraded(user)
    @account = user
    mail(to: "contact@boosket.com", subject: "Account upgraded")
  end

  def unsuscribe(user, reason)
    @account = user
    @reason = reason
    mail(to: "contact@boosket.com", subject: "Boosket Shop - #{t("mailer.users.unsuscribe.h1")}")
  end

end
