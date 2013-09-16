require 'spec_helper'

describe Match do
  it "is not completed or in progress when created" do
    match = Match.new
    
    match.completed.should be false
    match.in_progress.should be false
  end

  it "has many players" do
    match = Match.new

    match.players.count.should == 0
  end

  it "creates a given number of games before creation" do
    match = Match.create({:number_of_games => 7})

    match.games.count.should == 7
  end
end
