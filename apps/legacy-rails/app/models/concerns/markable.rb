module Markable
  extend ActiveSupport::Concern

  included do
    has_many :markers, as: :markable, dependent: :delete_all
  end

  def clear_marks_for(user)
    markers.where(user_id: user.id).delete_all
  end

  def mark!(user, label)
    markers.create(user_id: user.id, label: label) unless self.markers.where(user_id: user.id, label: label).exists?
  end

  def unmark!(user, label)
    markers.where(user_id: user.id, label: label).delete_all
  end

  def marked?(user, label)
    markers.where(user_id: user.id, label: label).exists?
  end

  def marks_count(label)
    markers.where(label: label).count
  end

  def users_marked_with(label)
    User.where(id: markers.where(label: label).pluck(:user_id))
  end

  def toggle_mark(user, label)
    if marked? user, label
      unmark! user, label
    else
      mark! user, label
    end
  end

  def get_mark_by user
    if marked?(user, 'saved')
      'Saved'
    elsif marked?(user, 'hidden')
      'Hidden'
    end
  end

  def is_reported(user)
    reported_elements = self.class.filtered_for(user, 'reported')
    reported_elements ? reported_elements.exists?(self) : false
  end

  def reported?
    markers.where(label: "reported").exists?
  end

  # methods defined here are going to extend the class, not the instance of it
  class_methods do

    def marked_with(user, *labels)
      joins(:markers).where markers: { user: user, label: labels }
    end

    def marked_with_no_visible_labels_for(user)
      marked_with user, 'reported', 'hidden'
    end

    def visible_for(user)
      where.not id: marked_with_no_visible_labels_for(user), publisher: user.reported_users
    end

    def reported_marks_for(admin)
      self.marked_with(admin.contacts, 'reported')
    end

  end

end
