namespace :events do
  desc "Renews recurring events"
  task renew_recurring: :environment do
    Event.where('repeat_frequency in (?) AND expires_at >= ? AND date < ?', %w[weekly monthly yearly],
      Time.zone.now, Time.zone.now).each do |event|
      case event.repeat_frequency
      when "weekly"
        event.date += 1.week
        event.end_time += 1.week if event.end_time.present?
      when "monthly"
        event.date += 1.month
        event.end_time += 1.month if event.end_time.present?
      when "yearly"
        event.date += 1.year
        event.end_time += 1.year if event.end_time.present?
      end
      event.save
      puts "update event: #{event.title}"
    end
  end
end