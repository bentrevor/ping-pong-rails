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
    post :create, :match => {:player1_name => "player1 name", 
                             :player2_name => "player2 name"}
    match = assigns(:match)

    Match.count.should == 1
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
    post :create, :match => {:player1_name => "player1 name", :player2_name => "player2 name"}
    post :create, :match => {:player1_name => "player1 name", :player2_name => "player2 name"}
    post :create, :match => {:player1_name => "player1 name", :player2_name => "player2 name"}
  end

  def create_four_completed_matches
    post :create, :match => {:player1_name => "player1 name", :player2_name => "player2 name", :completed => true}
    post :create, :match => {:player1_name => "player1 name", :player2_name => "player2 name", :completed => true}
    post :create, :match => {:player1_name => "player1 name", :player2_name => "player2 name", :completed => true}
    post :create, :match => {:player1_name => "player1 name", :player2_name => "player2 name", :completed => true}
  end
end
