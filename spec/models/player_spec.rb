require 'spec_helper'

describe Player do
  it "has a name" do
    player = Player.new({:name => "Ben"})
    player.name.should == "Ben"
  end
end
