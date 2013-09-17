class Match < ActiveRecord::Base
  has_many :games
  has_many :teams
  has_many :players, :through => :teams

  before_create :create_games

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

  def create_games
    if self.number_of_games.nil? or self.number_of_games.even?
      self.number_of_games = 3
    end

    self.number_of_games.times do
      self.games << Game.new
    end
  end
end
