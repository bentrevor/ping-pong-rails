require 'spec_helper'

describe Match do
  it "is not completed when created" do
    match = Match.new
    
    match.completed.should be false
  end

  it "has many players" do
    match = Match.new

    match.players.count.should == 0
  end

  it "creates three games before creation" do
    match = Match.create

    match.games.count.should == 3
  end
end
