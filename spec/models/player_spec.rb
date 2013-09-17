require 'spec_helper'

describe Player do
  it "can't have a blank name" do
    player = Player.new({:name => ""})

    player.save.should == false
  end

  it "needs a unique name" do
    Player.create({:name => "Ben"})
    player = Player.new({:name => "Ben"})

    player.save.should == false
  end

  it "has many teams" do
    player = Player.new

    player.teams.count.should == 0
  end
end
