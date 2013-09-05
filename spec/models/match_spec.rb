require 'spec_helper'

describe Match do
  it "has game and player ids" do
    match = Match.new

    match.should respond_to(:game1_id)
    match.should respond_to(:game2_id)
    match.should respond_to(:game3_id)
    match.should respond_to(:player1_id)
    match.should respond_to(:player2_id)
    match.should respond_to(:player3_id)
    match.should respond_to(:player4_id)
  end

  it "is not completed when created" do
    match = Match.new
    
    match.completed.should be false
  end

  it "requires at least two players" do
    match1 = Match.new({:player1_id => 1})
    match2 = Match.new({:player2_id => 1})

    match1.save.should == false
    match2.save.should == false
  end

  it "doesn't let duplicate ids play" do
    match1 = Match.new({:player1_id => 1,
                        :player2_id => 1})

    match2 = Match.new({:player1_id => 1,
                        :player2_id => 2,
                        :player3_id => 1,
                        :player4_id => 1})

    match3 = Match.new({:player1_id => 1,
                        :player2_id => 2,
                        :player3_id => 3,
                        :player4_id => 2})

    match1.save.should == false
    match2.save.should == false
    match3.save.should == false
  end

  it "can't have three players" do
    match1 = Match.new({:player1_id => 1,
                        :player2_id => 2,
                        :player3_id => 3})

    match2 = Match.new({:player1_id => 1,
                        :player2_id => 2,
                        :player4_id => 3})

    match1.save.should == false
    match2.save.should == false
  end
end
