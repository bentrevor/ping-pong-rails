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

  it "can edit a game" do
    Game.create({:match_id => 1})

    get :edit, :id => 1

    game = assigns(:game)

    game.match_id.should be 1
  end

  it "can finish a game" do
    Game.create({:match_id => 1})

    post :finish, :game => {:id           => Game.first.id,
                            :team_1_score => 11,
                            :team_2_score => 5}

    game = Game.first

    game.team_1_score.should == 11
    game.team_2_score.should == 5
    game.completed.should be true
  end

  it "can update the score without finishing a game" do
    create_three_games

    post :update, :id => Game.first.id, 
                  :game => {:team_1_score => 11,
                            :team_2_score  => 5}

    game = Game.first

    game.team_1_score.should == 11
    game.team_2_score.should == 5
    game.completed.should be false
  end

  private
  def create_three_games
    Game.create({:match_id => 1})
    Game.create({:match_id => 1})
    Game.create({:match_id => 1})
  end
end
