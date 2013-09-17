require 'spec_helper'

describe Match do
  it "is not completed or in progress when created" do
    match = Match.new
    
    match.completed.should be false
    match.in_progress.should be false
  end

  it "has many players through teams" do
    player1 = Player.create({:name => "player1"})
    player2 = Player.create({:name => "player2"})

    team = Team.create

    team.players << player1
    team.players << player2
    
    match = Match.create
    match.teams << team

    match.players.count.should == 2
  end

  it "creates a given number of games before creation" do
    match = Match.create({:number_of_games => 7})

    match.games.count.should == 7
  end

  it "has many teams" do
    match = Match.new

    match.teams.count.should == 0
  end
end
