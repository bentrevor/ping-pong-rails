require 'spec_helper'

describe Game do
  it "has ids for four player" do
    game = described_class.new

    game.should respond_to(:player1_id)
    game.should respond_to(:player2_id)
    game.should respond_to(:player3_id)
    game.should respond_to(:player4_id)
  end

  it "requires at least two players" do
    game = described_class.new({:player1_id => 1})

    game.save.should be false
  end
end
