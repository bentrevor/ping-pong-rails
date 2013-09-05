require 'spec_helper'

describe Match do
  it "is not completed when created" do
    match = Match.new
    
    match.completed.should be false
  end

  it "has and belongs to many players" do
    match = Match.new

    match.players.count.should == 0
  end
end
