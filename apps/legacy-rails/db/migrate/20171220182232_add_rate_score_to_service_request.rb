class AddRateScoreToServiceRequest < ActiveRecord::Migration
  def change
    add_column :service_requests, :rate_score, :integer, default: 0
  end
end
