class RefreshToken < ApplicationRecord
  belongs_to :user
  before_create :set_defaults
  after_create_commit :prune_old_tokens

  scope :active, -> { where(revoked_at: nil).where('expires_at > ?', Time.current) }

  def revoke!
    update!(revoked_at: Time.current)
  end

  private

  def set_defaults
    self.token ||= SecureRandom.hex(32)
    self.expires_at ||= 30.days.from_now
  end

  def prune_old_tokens
    max_tokens = ENV.fetch('REFRESH_TOKEN_MAX_PER_USER', '5').to_i
    return if max_tokens <= 0

    scope = RefreshToken.where(user_id: user_id).order(created_at: :desc)
    excess = scope.offset(max_tokens)
    excess.update_all(revoked_at: Time.current) if excess.exists?
  end
end
