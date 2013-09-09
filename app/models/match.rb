class Match < ActiveRecord::Base
  has_and_belongs_to_many :players
  has_many :games

  before_create :create_games

  private

  def create_games
    3.times do
      self.games << Game.new
    end
  end
end
