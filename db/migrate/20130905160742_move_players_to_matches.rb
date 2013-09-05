class MovePlayersToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :player1_id, :integer
    add_column :matches, :player2_id, :integer
    add_column :matches, :player3_id, :integer
    add_column :matches, :player4_id, :integer

    remove_column :games, :player1_id
    remove_column :games, :player2_id
    remove_column :games, :player3_id
    remove_column :games, :player4_id
  end
end
