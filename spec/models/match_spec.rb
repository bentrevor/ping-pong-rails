require 'spec_helper'

describe Match do
  let(:player1) { Player.new({:name => "first_player"}) }
  let(:player2) { Player.new({:name => "second_player"}) }
  let(:player3) { Player.new({:name => "third_player"}) }
  let(:player4) { Player.new({:name => "fourth_player"}) }

  let(:match) { Match.new({:player1 => player1, 
                           :player2 => player2}) }

  it "can have two players" do
    match.players.should include(player1)
    match.players.should include(player2)
    match.players.should_not include(player3)
    match.players.should_not include(player4)
  end

  it "can have four players" do
    match = Match.new({:player1 => player1,
                       :player2 => player2,
                       :player3 => player3,
                       :player4 => player4})

    match.players.should include(player1)
    match.players.should include(player2)
    match.players.should include(player3)
    match.players.should include(player4)
  end

  it "is not completed when it starts" do
    match.completed?.should == false
  end
end
