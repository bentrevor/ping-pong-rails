require 'spec_helper'
require 'app/controllers/teams_controller'

describe TeamsController do
  it "creates teams from player names" do
    player1 = Player.create({:name => "player1"})
    player2 = Player.create({:name => "player2"})

    post :create, :team => {:names => [player1.name, player2.name]}

    team = assigns :team

    team.players.count.should == 2
    team.players.first.name.should == player1.name
  end
end
