Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Json.new
  config.lograge.custom_options = lambda do |event|
    {
      params: event.payload[:params].except(*%w(controller action format)),
      request_id: event.payload[:request_id]
    }
  end
end
