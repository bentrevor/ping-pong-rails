class RemoveIds < ActiveRecord::Migration
  def change
    remove_column :games, :match_id, :integer

    remove_column :matches, :game1_id, :integer
    remove_column :matches, :game2_id, :integer
    remove_column :matches, :game3_id, :integer

    remove_column :matches, :player1_id, :integer
    remove_column :matches, :player2_id, :integer
    remove_column :matches, :player3_id, :integer
    remove_column :matches, :player4_id, :integer
  end
end
