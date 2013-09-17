require 'spec_helper'

describe Team do
  it "has many players" do
    team = Team.create

    team.players.count.should == 0
  end

  it "belongs to a match" do
    match = Match.create
    team = Team.create({:match_id => match.id})

    team.match.should_not be nil
  end
end
