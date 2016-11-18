class CreateDays < ActiveRecord::Migration[5.0]
  def change
    create_table :days do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :schedule, foreign_key: true

      t.timestamps
    end
  end
end
