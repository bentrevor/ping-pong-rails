class RenameScoreColumns < ActiveRecord::Migration
  def change
    rename_column :games, :winner_score, :team_1_score
    rename_column :games, :loser_score, :team_2_score
  end
end
