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

      puts Match.count

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
