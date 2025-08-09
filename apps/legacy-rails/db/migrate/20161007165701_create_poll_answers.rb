class CreatePollAnswers < ActiveRecord::Migration
  def change
    create_table :poll_answers do |t|
      t.references :poll
      t.string :name

      t.timestamps
    end
  end
end
