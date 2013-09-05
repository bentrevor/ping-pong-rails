class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :game1_id
      t.integer :game2_id
      t.integer :game3_id
      t.boolean :completed, :default => false

      t.timestamps
    end
  end
end
