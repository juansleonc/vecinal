class ChangeEventsDatesAndRemovesLogo < ActiveRecord::Migration

  def up
    change_table :events do |t|
      t.change  :date, :date
      t.remove  :repeat_frequency, :expires_at, :end_time, :category, :receiver_type, :receivers, :logo_file_name, :logo_content_type,
        :logo_file_size, :logo_updated_at
      t.time    :time_from, :time_to
    end
  end

  def down
    change_table :events do |t|
      t.change    :date, :datetime
      t.string    :repeat_frequency, :category
      t.datetime  :expires_at, :end_time
      t.string    :receiver_type, limit: 255
      t.text      :receivers
      t.string    :logo_file_name, limit: 255
      t.string    :logo_content_type, limit: 255
      t.integer   :logo_file_size
      t.datetime  :logo_updated_at
      t.remove    :time_from, :time_to
    end
  end

end
