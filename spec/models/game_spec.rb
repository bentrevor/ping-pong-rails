require 'spec_helper'

describe Game do
  it "has default values for scores and completed" do
    game = Game.new

    game.team_1_score.should == 0
    game.team_2_score.should == 0
    game.completed.should == false
  end

  it "belongs to a match" do
    match = Match.new
    team1 = Team.create({:match_id => match.id})
    team2 = Team.create({:match_id => match.id})
    
    team1.players << Player.create({:name => 'player1'})
    team2.players << Player.create({:name => 'player2'})

    match.teams << team1
    match.teams << team2

    match.save

    game = Game.create({:match_id => match.id})

    game.match.should_not be nil
  end
end
