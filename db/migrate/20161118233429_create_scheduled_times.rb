class CreateScheduledTimes < ActiveRecord::Migration[5.0]
  def change
    create_table :scheduled_times do |t|

      t.references :piece,    foreign_key: true
      t.references :day,      foreign_key: true
      t.datetime :start_time

      t.timestamps
    end
  end
end
