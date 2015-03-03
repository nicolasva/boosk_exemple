if Rails.env == 'production'
  Rails.application.config.middleware.use ExceptionNotifier,
      :email_prefix => "[BoosketShops::ExceptionNotifier] ",
      :sender_address => %{"BoosketShops::ExceptionNotifier" <notifier@boosket.com>},
      :exception_recipients => %w{dev@boosket.com}
end
