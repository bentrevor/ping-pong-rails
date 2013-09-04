require 'spec_helper'

describe Game do
  it "has ids for four players" do
    game = Game.new

    game.should respond_to(:player1_id)
    game.should respond_to(:player2_id)
    game.should respond_to(:player3_id)
    game.should respond_to(:player4_id)
  end

  it "requires at least two players" do
    game1 = Game.new({:player1_id => 1})
    game2 = Game.new({:player2_id => 1})

    game1.save.should be false
    game2.save.should be false
  end

  it "doesn't let duplicate ids play" do
    game1 = Game.new({:player1_id => 1,
                      :player2_id => 1})

    game2 = Game.new({:player1_id => 1,
                      :player2_id => 2,
                      :player3_id => 1,
                      :player4_id => 1})

    game3 = Game.new({:player1_id => 1,
                      :player2_id => 2,
                      :player3_id => 3,
                      :player4_id => 2})

    game1.save.should be false
    game2.save.should be false
    game3.save.should be false
  end

  it "can't have three players" do
    game1 = Game.new({:player1_id => 1,
                      :player2_id => 2,
                      :player3_id => 3})

    game2 = Game.new({:player1_id => 1,
                      :player2_id => 2,
                      :player4_id => 3})

    game1.save.should be false
    game2.save.should be false
  end
end
