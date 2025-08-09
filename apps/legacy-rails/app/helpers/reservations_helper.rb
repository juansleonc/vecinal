module ReservationsHelper
  def status_translated_from_comment comment
    status = comment.content.split(' ').last
    status_translated = t "reservations.statuses.#{status}"
    status_translated.downcase
  end
end
