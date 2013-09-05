class AddWinnerAndScoreToGame < ActiveRecord::Migration
  def change
    add_column :games, :winner,       :integer, :default => 0
    add_column :games, :winner_score, :integer, :default => 0
    add_column :games, :loser_score,  :integer, :default => 0
  end
end
