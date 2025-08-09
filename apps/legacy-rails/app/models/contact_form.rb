class ContactForm

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :email, :subject, :message

  validates :name, presence: true
  validates :email, presence: true
  validates :subject, presence: true
  validates :message, presence: true


  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

end