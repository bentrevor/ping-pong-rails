require 'spec_helper'

describe "Game pages" do
  describe "#show" do
    it "can view a game" do
      player1 = Player.create({:name => "player1"})
      player2 = Player.create({:name => "player2"})
      match = Match.new
      match.players << player1
      match.players << player2

      match.save

      Game.create({:match_id => match.id})

      visit '/games/1'

      page.body.should have_content 'player1 vs. player2'
    end
  end
end
