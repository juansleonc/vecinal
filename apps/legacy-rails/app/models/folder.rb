class Folder < ActiveRecord::Base

  LIMIT_HEIGHT = 10
  PER_PAGE = 20

  belongs_to :folderable, polymorphic: true
  belongs_to :created_by, class_name: 'User'
  belongs_to :father, class_name: 'Folder'
  has_many :sub_folders, class_name: 'Folder', foreign_key: 'father_id', dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy

  before_validation :set_defaults
  # before_destroy :not_root_folder

  validates :folderable, presence: true
  validates :name, presence: true
  validates :created_by, presence: true, if: 'father.present?'
  validates :level, presence: true, numericality: { only_integer: true, less_than: LIMIT_HEIGHT }
  validate :not_father_self

  scope :search_by, -> (query) { distinct.where 'name ILIKE :query', query: "%#{query}%" }

  def self.roots_by_user(user)
    if user.admin? || user.collaborator?
      where('(folderable_type = ? AND folderable_id = ?) OR (folderable_type = ? AND folderable_id IN (?))',
        'Company', user.accountable.id, 'Building', user.accountable.buildings.ids
      ).where father: nil
    elsif user.resident? || user.board_member? || user.tenant? || user.agent?
      where folderable: user.accountable, father: nil
    end
  end

  def full_tree
    folders = []
    folder = self
    while folder.father
      folder = folder.father
      folders << folder
    end
    folders.reverse
  end

  def update_sizes(attachment_size, type = :add)
    folder = self
    op = type == :add ? :+ : :-
    while folder
      folder.update_attributes size: folder.size.send(op, attachment_size.to_i)
      folder = folder.father
    end
  end


private

  def not_father_self
    errors.add(:father, :not_self) if father == self
  end

  def set_defaults
    if father.present?
      self.level = father.level + 1
      self.folderable = father.folderable
    else
      self.level = 0
    end
  end

  def not_root_folder
    unless father
      errors.add(:base, :can_not_delete_root_folder)
      return false
    end
  end

end
