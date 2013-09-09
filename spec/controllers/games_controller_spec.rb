require 'spec_helper'
require 'app/controllers/games_controller'

describe GamesController do
  it "can create a game without saving it" do
    get :new
    game = assigns(:game)

    Game.count.should == 0
    game.should_not == nil
    game.completed.should == false
  end

  it "can save a game" do
    post :create, :game => {:match_id => 1}
    game = assigns(:game)

    Game.count.should == 1
    game.match_id.should == 1
  end

  it "can list all games" do
    create_three_games

    get :index

    games = assigns(:games)

    games.length.should == 3
  end

  it "can finish a game" do
    create_three_games

    post :finish, :game => {:id           => 1,
                            :winner_score => 11,
                            :loser_score  => 5,
                            :winner       => 1}

    game = Game.find 1

    game.winner_score.should == 11
    game.loser_score.should == 5
    game.completed.should be true
  end

  private
  def create_three_games
    Game.create({:match_id => 1})
    Game.create({:match_id => 1})
    Game.create({:match_id => 1})
  end
end
