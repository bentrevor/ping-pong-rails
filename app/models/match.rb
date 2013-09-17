class Match < ActiveRecord::Base
  has_many :games
  has_many :teams
  has_many :players, :through => :teams

  before_create :create_games
  validate :two_or_four_players

  def players
    players = []
    
    self.teams.each do |team|
      team.players.each do |player|
        players << player
      end
    end

    players
  end

  private

  def two_or_four_players
    if players.length != 2 and players.length != 4
      errors[:number_of_players] = "Must have two or four players."
    end
  end

  def create_games
    if self.number_of_games.nil? or self.number_of_games.even?
      self.number_of_games = 3
    end

    self.number_of_games.times do
      self.games << Game.new
    end
  end
end
