class CreateConflicts < ActiveRecord::Migration[5.0]
  def change
    create_table :conflicts do |t|
      t.references :contact, foreign_key: true
      t.references :location, foreign_key: true
      t.string :description
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end

    add_index :conflicts, [:start_time]
  end
end
