class CreateDays < ActiveRecord::Migration[5.0]
  def change
    create_table :days do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.references :schedule, foreign_key: true

      t.timestamps
    end
  end
end
