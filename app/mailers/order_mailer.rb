class OrderMailer < ActionMailer::Base
  default from: "no-reply@boosket.com"

  def pay_for_merchant(order)
    recipients = order.shop.contact.emails.map(&:email)
    @order = order
    attachments.inline['boosket-shop.png'] = File.read("#{Rails.root}/app/assets/images/boosket-shop.png")
    mail(:to => recipients, :subject => t("mailer.orders.pay_for_merchant.subject"))
  end

  def pay_for_customer(order)
    @order = order
    if @order.shop.customization.header.picture.url == @order.shop.customization.header.picture.default_url
      attachments.inline['merchant-shop.png'] = File.read("#{Rails.root}/app/assets/images/fallback/header_default.jpg")
    else
      attachments.inline['merchant-shop.png'] = File.read("#{Rails.root}/public#{@order.shop.customization.header.picture.url}")
    end
    mail(:to => order.contact.emails.first.email, :subject => t("mailer.orders.pay_for_customer.subject", :shop_name => @order.shop.name))
  end

  def status_for_customer(order, status)
    @order = order
    @status = status
    if @order.shop.customization.header.picture.url == @order.shop.customization.header.picture.default_url
      attachments.inline['merchant-shop.png'] = File.read("#{Rails.root}/app/assets/images/fallback/header_default.jpg")
    else
      attachments.inline['merchant-shop.png'] = File.read("#{Rails.root}/public#{@order.shop.customization.header.picture.url}")
    end
    mail(:to => order.contact.emails.first.email, :subject => t("mailer.orders.status_for_customer.subject", :status => t("mailer.orders.common.subject.status.#{status}"),:shop_name => "#{@order.shop.name}"))
  end
end
