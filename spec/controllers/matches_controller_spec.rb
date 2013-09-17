require 'spec_helper'
require 'app/controllers/matches_controller'

describe MatchesController do
  context "creating matches" do
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

    describe "creating games" do
      it "can have an odd number of games" do
        post :create, :match => {:names => ["name 1", "name 2"], :number_of_games => 5}

        match = Match.first

        match.games.length.should == 5
      end

      it "can't have an even number of games" do
        post :create, :match => {:names => ["name 1", "name 2"], :number_of_games => 4}

        match = Match.first

        match.games.length.should == 3
      end

      it "defaults to having three games" do
        post :create, :match => {:names => ["name 1", "name 2"]}

        match = Match.first

        match.games.length.should == 3
      end
    end

    it "can delete a match" do
      match = Match.create({:number_of_games => 3})

      delete :destroy, :id => match.id

      Match.count.should == 0
    end

    describe "redirects" do
      it "redirects to waiting list after creation" do
        player1 = Player.create({:name => "player1 name"})
        player2 = Player.create({:name => "player2 name"})

        post :create, :match => {:names => [player1.name, player2.name]}

        response.should redirect_to('/matches/waiting_list')
      end

      it "redirects to waiting list after destruction" do
        match = Match.new
        match.save

        delete :destroy, :id => match.id

        response.should redirect_to('/matches/waiting_list')
      end

      it "redirects to show after updating" do
        match = Match.new
        match.save

        post :update, :id => match.id, :match =>
                                         {:game1 => {:team_1_score => 1, :team_2_score => 2},
                                          :game2 => {:team_1_score => 3, :team_2_score => 4},
                                          :game3 => {:team_1_score => 5, :team_2_score => 6}}

        response.should redirect_to("/matches/#{match.id}")
      end
    end
  end

  context "updating match state" do
    it "can start a match" do
      match = Match.create({:number_of_games => 3})

      post :start, :id => match.id

      match = assigns(:match)

      match.in_progress.should == true
    end

    it "can only start one match at a time" do
      Match.create
      Match.create

      post :start, :id => Match.first
      post :start, :id => Match.last

      Match.first.in_progress.should == true
      Match.last.in_progress.should == false
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
  end


  context "listing matches" do
    it "can list all matches" do
      create_three_matches
      create_four_completed_matches

      get :index

      matches = assigns(:matches)

      matches.length.should == 7
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

    it "can show the in_progress match" do
      create_three_matches
      create_four_completed_matches

      post :start, :id => Match.last.id

      get :in_progress

      match_in_progress = assigns(:in_progress)

      match_in_progress.should == Match.last
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
