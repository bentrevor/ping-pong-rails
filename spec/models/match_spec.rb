require 'spec_helper'

describe Match do
  it "has ids for four player" do
    match = Match.new

    match.should respond_to(:player1_id)
    match.should respond_to(:player2_id)
    match.should respond_to(:player3_id)
    match.should respond_to(:player4_id)
  end

  it "requires at least two players" do
    match = Match.new({:player1_id => 1})

    match.save.should be false
  end

  it "starts not completed" do
    match = Match.new({:player1_id => 1,
                       :player2_id => 2})

    match.completed.should be false
  end
end
