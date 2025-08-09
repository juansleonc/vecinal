module DashboardHelper

  def type_growth increase
    if increase > 0
      'up'
    elsif increase < 0
      'down'
    else
      'none'
    end
  end

  def table_name model
    model.name.underscore.pluralize
  end

  def between_date now, past
    if now.year == past.year
      if now.month == past.month
        "#{past.strftime('%d')} - #{now.strftime('%d %b %Y')}"
      else
        "#{past.strftime('%d %b')} - #{now.strftime('%d %b %Y')}"
      end
    else
      "#{past.strftime('%b %Y')} - #{now.strftime('%b %Y')}"
    end
  end

  def versus_dates date1, date2
    "#{date1.srtftime('%b %d, %y')} vs #{date2.srtftime('%b %d, %y')}"
  end

  def anchor_id community
    "#{community.class.name.downcase}#{community.id}-option"
  end

  def str_to_time(str)
    str_a = str.split('.')
    str_a.first.to_i.send(str_a.last)
  end

end