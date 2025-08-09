namespace :subscription do
  desc "Updates all subscriptions states"
  task update_status: :environment do
    Company.all.each do |company|
      company.update_subscription_status
    end
    Business.all.each do |business|
      business.update_subscription_status
    end
  end
end
