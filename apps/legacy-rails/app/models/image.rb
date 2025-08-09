class Image < ActiveRecord::Base

  ALLOWED_CONTENT_TYPES = ["image/jpg", "image/jpeg", "image/png", "image/gif", "image/x-png", "image/pjpeg"]
  ALLOWED_IMAGE_EXTENSIONS = ["jpg", "jpeg", "png", "gif", "x-png", "pjpeg"]

  MAX_SIZE = 10.megabytes

  MAX_IN_TIMELINE = 4

  belongs_to :imageable, polymorphic: true

  has_attached_file :image, default_url: :default_image,
    styles: { standard: "160x160#", thumb: "230x205#", medium_thumb: "345x240#", public: "945x366#" },
    processors: [:thumbnail, :compression]

  validates_attachment_content_type :image, content_type: ALLOWED_CONTENT_TYPES
  validates_attachment_size :image, less_than: MAX_SIZE

  before_save :set_home_unique

  scope :home_image, -> { where(home: true).first }

  def self.allowed_extensions
    ALLOWED_IMAGE_EXTENSIONS.map{ |e| '.' + e }.join(',')
  end

  def default_image
    'image_:style.jpg'
  end

private

  def set_home_unique
    Image.where(imageable: imageable).where.not(id: id).update_all(home: false) if home?
  end

end

class ImageCompany < Image
  def default_image
    'condomedia_cover_:style.jpg'
  end
end

class ImageBuilding < Image
  def default_image
    'condomedia_cover_:style.jpg'
  end
end

class ImageBusiness < Image
  def default_image
    'condomedia_cover_:style.jpg'
  end
end

class ImageAmenity < Image
  def default_image
    'condomedia_cover_:style.jpg'
  end
end

class ImageUser < Image
  def default_image
    'condomedia_cover_:style.jpg'
  end
end

