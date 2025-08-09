module Attachmentable
  extend ActiveSupport::Concern

  included do
    has_many :attachments, as: :attachmentable, dependent: :destroy
    accepts_nested_attributes_for :attachments, allow_destroy: true
  end

  def attachment_col_size
    'col-xs-6'
  end

  def attachment_visibility(index)
    'hidden' if index > 3
  end

  # methods defined here are going to extend the class, not the instance of it
  class_methods do

  end

end