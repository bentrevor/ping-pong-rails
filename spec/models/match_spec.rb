require 'spec_helper'

describe Match do
  it "has game ids" do
    match = Match.new

    match.should respond_to(:game1_id)
    match.should respond_to(:game2_id)
    match.should respond_to(:game3_id)
  end

  it "is not completed when created" do
    match = Match.new
    
    match.completed.should be false
  end
end
