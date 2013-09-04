class RenameMatchToGame < ActiveRecord::Migration
  def change
    rename_table :matches, :games
  end
end
