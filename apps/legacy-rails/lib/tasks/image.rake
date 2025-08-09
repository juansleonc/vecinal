namespace :images do
  desc "Destroys old unused images"
  task destroy_old_unused: :environment do
    Image.destroy_all(['imageable_id IS NULL AND created_at <= ?', 1.day.ago])
  end
end