class AddWinnerAndDateCompleted < ActiveRecord::Migration
  def change
    add_column :matches, :completed_at, :datetime

    add_column :matches, :winner, :integer
  end
end
