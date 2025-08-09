class RefreshToken < ApplicationRecord
  belongs_to :user
  before_create :set_defaults

  scope :active, -> { where(revoked_at: nil).where('expires_at > ?', Time.current) }

  def revoke!
    update!(revoked_at: Time.current)
  end

  private

  def set_defaults
    self.token ||= SecureRandom.hex(32)
    self.expires_at ||= 30.days.from_now
  end
end
