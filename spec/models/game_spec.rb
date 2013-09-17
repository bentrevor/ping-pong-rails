require 'spec_helper'

describe Game do
  it "has default values for scores and completed" do
    game = Game.new

    game.team_1_score.should == 0
    game.team_2_score.should == 0
    game.completed.should == false
  end

  it "belongs to a match" do
    match = Match.create
    game = Game.create({:match_id => match.id})

    game.match.should_not be nil
  end
end
