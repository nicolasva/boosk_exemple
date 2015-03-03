class ShopMailer < ActionMailer::Base
  default from: "api@boosket.com"

  def results_import(product_feed)
    recipients = product_feed.shop.contact.emails.map(&:email)
    @shop = product_feed.shop
    @user = @shop.users.master
    @errors = product_feed.errors_feed
    attachments.inline['boosket-shop.png'] = File.read("#{Rails.root}/app/assets/images/boosket-shop.png")
    mail(to: recipients, subject: "Boosket Shop - Validation d'imports de flux")
  end

end
