class Attachment < ActiveRecord::Base

  include Countable

  ALLOWED_IMAGE_EXTENSIONS = ["jpg", "jpeg", "png", "gif", "x-png", "pjpeg"]
  ALLOWED_DOCUMENT_EXTENSIONS = ["pdf", "doc", "docx", "ppt", "pptx", "xls", "xlsx", "PDF", "DOC", "DOCX", "PPT", "PPTX", "XLS", "XLSX"]
  ALL_ALLOWED_EXTENSIONS = ALLOWED_IMAGE_EXTENSIONS + ALLOWED_DOCUMENT_EXTENSIONS
  MAX_FILES = 10
  MAX_FILE_SIZE = 30.megabytes
  MAX_FILE_SIZE_HUMAN = ActionController::Base.helpers.number_to_human_size MAX_FILE_SIZE

  IMAGES_NAMES_MAP = {
    pdf: 'attachment_pdf.svg',
    PDF: 'attachment_pdf.svg',
    doc: 'https://static2.sharepointonline.com/files/fabric/assets/brand-icons/document/svg/docx_48x1.svg',
    DOC: 'https://static2.sharepointonline.com/files/fabric/assets/brand-icons/document/svg/docx_48x1.svg',
    docx: 'https://static2.sharepointonline.com/files/fabric/assets/brand-icons/document/svg/docx_48x1.svg',
    DOCX: 'https://static2.sharepointonline.com/files/fabric/assets/brand-icons/document/svg/docx_48x1.svg',
    ppt: 'https://static2.sharepointonline.com/files/fabric/assets/brand-icons/document/svg/pptx_48x1.svg',
    PPT: 'https://static2.sharepointonline.com/files/fabric/assets/brand-icons/document/svg/pptx_48x1.svg',
    pptx: 'https://static2.sharepointonline.com/files/fabric/assets/brand-icons/document/svg/pptx_48x1.svg',
    PPTX: 'https://static2.sharepointonline.com/files/fabric/assets/brand-icons/document/svg/pptx_48x1.svg',
    XLS: 'https://static2.sharepointonline.com/files/fabric/assets/brand-icons/document/svg/xlsx_48x1.svg',
    xlsx: 'https://static2.sharepointonline.com/files/fabric/assets/brand-icons/document/svg/xlsx_48x1.svg',
    XLSX: 'https://static2.sharepointonline.com/files/fabric/assets/brand-icons/document/svg/xlsx_48x1.svg'
  }

  PER_PAGE = 20

  belongs_to :attachmentable, polymorphic: true
  belongs_to :created_by, class_name: 'User'
  alias_attribute :user, :created_by 

  has_attached_file :file_attachment, :styles => { thumb: "160x160#",  medium_thumb: "750x508#"},
    processors: [:thumbnail, :compression]

  validates_attachment :file_attachment, presence: true, size: { less_than: MAX_FILE_SIZE, max_size: MAX_FILE_SIZE_HUMAN }
  do_not_validate_attachment_file_type :file_attachment # We're going to use our own validation for this
  validate :correct_content_type
  validates :created_by, presence: true, if: :belongs_to_folder?

  before_post_process :image?

  scope :search_by, -> (query) { 
    raw_sql = ''
    query_parts = query.split(' ')
    query_parts.each do |part|
      if raw_sql != ''
        raw_sql += " OR "
      end
      raw_sql += " file_attachment_file_name ILIKE '%#{part}%' "
           
    end
    distinct.where(raw_sql)
  
  }
  scope :by_adaptive, -> (users, type) {where(user: users, attachmentable_type: type)}
  scope :beetwen, -> (date1, date2, users, type) { where('created_at >= ? and created_at <= ? and attachmentable_type = ?', date1, date2, type).by_adaptive(users, type) }

  def self.files_count start, final, users
    beetwen(start, final, users, 'Folder').count
  end

  def self.storage_count start, final, users
    presents_beetwen(start, final, users).sum(:file_attachment_file_size)
  end

  def self.all_extensions_to_s
    ALL_ALLOWED_EXTENSIONS.map{ |e| '.' + e }.join(',')
  end

  def correct_content_type
    errors.add(:base, ", Only Images, Pdf, Word, Excel and PowerPoint files are allowed.") unless ALL_ALLOWED_EXTENSIONS.include?(file_extension)
  end

  def image?
    ALLOWED_IMAGE_EXTENSIONS.include? file_extension
  end

  def file_extension
    file_attachment_file_name.split('.').last
  end

  def image_col_size(index)
    images = attachmentable.images.count
    col_size = 12
    if images == 2
      col_size = 6
    elsif images == 3
      if index == 0
        col_size = 8
      else
        col_size = 4
      end
    elsif images >= 4
      if index == 0
        col_size = 12
      elsif index < 4
        col_size = 4
      else
        col_size = '0 hidden'
      end
    end
    return col_size
  end

private

  def belongs_to_folder?
    attachmentable_type == 'Folder'
  end

end
