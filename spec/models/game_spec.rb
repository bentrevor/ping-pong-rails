require 'spec_helper'

describe Game do
  it "has default values for winner, scores, and completed" do
    game = Game.new

    game.team_1_score.should == 0
    game.team_2_score.should == 0
    game.completed.should == false
  end
end
