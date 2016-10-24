class CreateSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :schedules do |t|
      t.string :name
      t.integer :actor_transition_time
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
