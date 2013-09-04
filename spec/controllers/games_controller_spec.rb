require 'spec_helper'
require 'app/controllers/games_controller'

describe GamesController do
  it "can create a game without saving it" do
    get :new
    game = assigns(:game)

    Game.count.should == 0
    game.should_not == nil
    game.player1_id.should == nil
  end

  it "can save a game" do
    post :create, :game => {:player1_id => 1, :player2_id => 2}
    game = assigns(:game)

    Game.count.should == 1
    game.player1_id.should == 1
    game.player2_id.should == 2
    game.player3_id.should == nil
    game.player4_id.should == nil
  end

  it "can list all games" do
    create_three_games

    get :index

    games = assigns(:games)

    games.length.should == 3
  end

  private
  def create_three_games
    Game.create({:player1_id => 1, :player2_id => 2})
    Game.create({:player1_id => 1, :player2_id => 2})
    Game.create({:player1_id => 1, :player2_id => 2})
  end
end
