class AddTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.belongs_to :match
    end

    create_table :players_teams do |t|
      t.belongs_to :player
      t.belongs_to :team
    end
  end
end
