module Folderable
  extend ActiveSupport::Concern

  included do
    has_one :folder, as: :folderable, dependent: :destroy

    after_create :create_root_folder
  end

  def create_root_folder
    Folder.create folderable: self, name: self.name
  end

end