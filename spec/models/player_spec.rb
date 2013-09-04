require 'spec_helper'

describe Player do
  it "has a name" do
    player = Player.new({:name => "Ben"})

    player.name.should == "Ben"
  end

  it "can't have a blank name" do
    player = Player.new({:name => ""})

    player.save.should be false
  end
end
