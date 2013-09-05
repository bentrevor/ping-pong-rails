require 'spec_helper'

describe Game do
  it "has default values for winner, scores, and completed" do
    game = Game.new

    game.winner.should == 0
    game.winner_score.should == 0
    game.loser_score.should == 0
    game.completed.should == false
  end
end
