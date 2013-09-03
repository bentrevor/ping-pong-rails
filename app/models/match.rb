require 'virtus'

class Match
  include Virtus

  attribute :player1, Player
  attribute :player2, Player
  attribute :player3, Player
  attribute :player4, Player
  attribute :completed, Boolean, :default => false
  attribute :winner,  Player

  def players
    if two_players_match?
      [@player1, @player2]
    else
      [@player1, @player2, @player3, @player4]
    end
  end

  private
  def two_players_match?
    @player3.nil?
  end
end
