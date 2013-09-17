require 'spec_helper'

describe Team do
  it "has many players" do
    team = Team.create

    team.players.count.should == 0
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

    team1.match.should_not be nil
  end
end
