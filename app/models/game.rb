class Game < ActiveRecord::Base
  validates :player1_id, :presence => true
  validates :player2_id, :presence => true
end
