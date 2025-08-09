Paperclip::Attachment.default_options.update({
  :url => "/system/:hash.:extension",
  :hash_secret => Rails.application.secrets.paperclip_url_secret
})