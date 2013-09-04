require 'spec_helper'
require 'app/controllers/players_controller'
require 'app/models/player'

describe PlayersController do
  it "can create a Player" do
    post :create, :player => {:name => "Ben"}

    Player.count.should == 1
  end

  it "can create a Player without saving it" do
    get :new

    Player.count.should == 0
    assigns(:player).should_not be nil
  end

  it "can list all players" do
    add_players "player1", "player2", "player3"
    get :index

    players = assigns(:players)

    players.length.should == 3
  end
end
