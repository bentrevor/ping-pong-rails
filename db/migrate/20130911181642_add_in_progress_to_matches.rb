class AddInProgressToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :in_progress, :boolean, :default => false
    add_column :matches, :number_of_games, :integer

    remove_column :games, :winner, :integer
  end
end
