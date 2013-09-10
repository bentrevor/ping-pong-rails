require 'spec_helper'
require 'app/controllers/matches_controller'

describe MatchesController do
  it "can create a match without saving it" do
    get :new
    match = assigns(:match)

    Match.count.should == 0
    match.should_not == nil
  end

  it "can create a match given two names" do
    post :create, :match => {:names => ["name 1", "name 2"]}

    Match.count.should == 1
  end

  it "knows which players are playing" do
    player1 = Player.create({:name => "player1 name"})
    player2 = Player.create({:name => "player2 name"})

    post :create, :match => {:names => [player1.name, player2.name]}

    match = assigns(:match)

    match.players.count.should == 2
    match.players.first.name.should == player1.name
  end

  it "can finish a match" do
    match = Match.new
    match.save

    post :update, :id => match.id, :match =>
                                     {:game1 => {:team_1_score => 1, :team_2_score => 2},
                                      :game2 => {:team_1_score => 3, :team_2_score => 4},
                                      :game3 => {:team_1_score => 5, :team_2_score => 6}}

    match = assigns(:match)
    game1 = match.games[0]
    game2 = match.games[1]
    game3 = match.games[2]

    match.completed.should == true
    game1.team_1_score.should == 1
    game1.team_2_score.should == 2
    game2.team_1_score.should == 3
    game2.team_2_score.should == 4
    game3.team_1_score.should == 5
    game3.team_2_score.should == 6
  end

  it "can delete a match" do
    match = Match.new
    match.save

    delete :destroy, :id => match.id

    Match.count.should == 0
  end

  context "listing matches" do
    it "can list all matches" do
      create_three_matches

      get :index

      matches = assigns(:matches)

      matches.length.should == 3
    end

    it "can list all incomplete matches" do
      create_three_matches
      create_four_completed_matches

      get :waiting_list

      matches = assigns(:matches)

      matches.length.should == 3
    end

    it "can list all completed matches" do
      create_three_matches
      create_four_completed_matches

      get :finished

      matches = assigns(:matches)

      matches.length.should == 4
    end
  end

  private
  def create_three_matches
    post :create, :match => {:names => ["player1 name", "player2 name"]}
    post :create, :match => {:names => ["player1 name", "player2 name"]}
    post :create, :match => {:names => ["player1 name", "player2 name"]}
  end

  def create_four_completed_matches
    post :create, :match => {:names => ["player1 name", "player2 name"], :completed => true}
    post :create, :match => {:names => ["player1 name", "player2 name"], :completed => true}
    post :create, :match => {:names => ["player1 name", "player2 name"], :completed => true}
    post :create, :match => {:names => ["player1 name", "player2 name"], :completed => true}
  end
end
