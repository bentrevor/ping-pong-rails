class SetUpAssociations < ActiveRecord::Migration
  def change
    create_table :matches_players do |t|
      t.belongs_to :match
      t.belongs_to :player
    end

    change_table :games do |t|
      t.belongs_to :match
    end
  end
end
