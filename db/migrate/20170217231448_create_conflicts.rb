class CreateConflicts < ActiveRecord::Migration[5.0]
  def change
    create_table :conflicts do |t|
      t.references :contact, foreign_key: true
      t.references :location, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
