class Match < ActiveRecord::Base
  has_and_belongs_to_many :players
  has_many :games

  before_create :create_games

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
