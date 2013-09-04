require 'spec_helper'
require 'app/controllers/players_controller'
require 'app/models/player'

describe PlayersController do
  it "can create a Player" do
    post :create, :name => "Ben"

    Player.count.should == 1
  end
end
