class UserDecorator
  include ActionView::Helpers::NumberHelper

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def mobile_phone
    number_to_phone user.contact_details.mobile_phone
  end

  def method_missing(method_name, *args, &block)
    user.send(method_name, *args, &block)
  end

  def respond_to_missing?(method_name, include_private = false)
    user.respond_to?(method_name, include_private) || super
  end

end