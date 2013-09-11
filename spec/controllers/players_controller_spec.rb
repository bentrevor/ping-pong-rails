require 'spec_helper'
require 'app/controllers/players_controller'
require 'app/models/player'

describe PlayersController do
  it "can list all players" do
    player1 = Player.create({:name => 'player1'})
    player2 = Player.create({:name => 'player2'})
    player3 = Player.create({:name => 'player3'})

    get :index

    players = assigns(:players)

    players.length.should == 3
  end

  it "can show a player" do
    created_player = Player.create({:name => "Ben"})

    get :show, :id => created_player.id

    player = assigns(:player)

    player.should == created_player
  end
end
