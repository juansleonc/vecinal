module Unreadable
  extend ActiveSupport::Concern

  included do
    acts_as_readable on: :created_at
    after_create :mark_as_read_for_sender, unless: :comment?
  end

  def mark_as_read_for_sender
    mark_as_read! for: user
  end

  def mark_as_replied_by(user)
    read_marks.where(reader_type: user.class.name).where.not(reader_id: user.id).delete_all
  end

  def comment?
    self.class.name == 'Comment'
  end

end