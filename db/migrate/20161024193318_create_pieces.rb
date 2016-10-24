class CreatePieces < ActiveRecord::Migration[5.0]
  def change
    create_table :pieces do |t|
      t.string :title
      t.integer :length
      t.integer :setup
      t.integer :cleanup
      t.references :location, foreign_key: true
      t.integer :rating
      t.references :day, foreign_key: true
      t.integer :start_time
      t.references :schedule, foreign_key: true

      t.timestamps
    end
  end
end
