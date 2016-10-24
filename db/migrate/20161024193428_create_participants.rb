class CreateParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :participants do |t|
      t.references :contact, foreign_key: true
      t.references :piece, foreign_key: true

      t.timestamps
    end
  end
end
