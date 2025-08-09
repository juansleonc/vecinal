module PollsHelper

  def time_countdown_in_words(coming_date)
    if coming_date > Time.zone.now
      time_ago_in_words(coming_date) + ' ' + t('general.left')
    else
      t 'general.closed'
    end
  end

end
