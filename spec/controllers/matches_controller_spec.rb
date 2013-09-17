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

    describe "creating teams" do
      it "makes two teams for singles matches" do
        post :create, :match => {:names => ["name 1", "name 2"]}

        Team.count.should == 2
      end

      it "makes two teams for doubles matches" do
        post :create, :match => {:names => ["name 1", 
                                            "name 2",
                                            "name 3",
                                            "name 4"]}

        Team.count.should == 2
      end
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
      post :create, :match => {:names => ["name 1", "name 2"], :number_of_games => 3}

      delete :destroy, :id => Match.first.id

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
        post :create, :match => {:names => ["name 1", "name 2"], :number_of_games => 3}

        delete :destroy, :id => Match.first.id

        response.should redirect_to('/matches/waiting_list')
      end

      it "redirects to show after updating" do
        post :create, :match => {:names => ["name 1", "name 2"], :number_of_games => 3}

      post :update, :id => Match.first.id, :match =>
                                             {:game1 => {:team_1_score => 1, :team_2_score => 2},
                                              :game2 => {:team_1_score => 3, :team_2_score => 4},
                                              :game3 => {:team_1_score => 5, :team_2_score => 6}}

        response.should redirect_to("/matches/#{Match.first.id}")
      end
    end
  end

  context "updating match state" do
    it "redirects to in_progress when a match starts" do
      post :create, :match => {:names => ["name 1", "name 2"], :number_of_games => 3}

      post :start, :id => Match.first.id

      match = assigns(:match)

      match.in_progress.should == true
      response.should redirect_to '/matches/in_progress'
    end

    it "can only start one match at a time" do
      post :create, :match => {:names => ["name 1", "name 2"], :number_of_games => 3}
      post :create, :match => {:names => ["name 1", "name 2"], :number_of_games => 3}

      post :start, :id => Match.first
      post :start, :id => Match.last

      Match.first.in_progress.should == true
      Match.last.in_progress.should == false
    end

    it "can update a match without completing it" do
      post :create, :match => {:names => ["name 1", "name 2"], :number_of_games => 3}

      post :update, :id => Match.first.id, :match =>
                                             {:game1 => {:team_1_score => 1, :team_2_score => 2},
                                              :game2 => {:team_1_score => 3, :team_2_score => 4},
                                              :game3 => {:team_1_score => 5, :team_2_score => 6}}

      match = assigns(:match)
      game1 = match.games[0]
      game2 = match.games[1]
      game3 = match.games[2]

      match.completed.should == false
      game1.team_1_score.should == 1
      game1.team_2_score.should == 2
      game2.team_1_score.should == 3
      game2.team_2_score.should == 4
      game3.team_1_score.should == 5
      game3.team_2_score.should == 6
    end

    describe "finishing a match" do
      before :each do
        post :create, :match => {:names => ["name 1", "name 2"], :number_of_games => 3}

        post :update, :id => Match.first.id, :match =>
                                               {:game1 => {:team_1_score => 11, :team_2_score => 2},
                                                :game2 => {:team_1_score => 11, :team_2_score => 4},
                                                :game3 => {:team_1_score => 11, :team_2_score => 6}}

        post :finish, :id => Match.first.id
        @match = assigns(:match)
      end

      it "can declare a winner" do
        @match.winner.should == @match.teams.first.id
      end

      it "is completed and not in progress" do
        @match.completed.should == true
        @match.in_progress.should == false
      end

      it "redirects to the match" do
        response.should redirect_to @match
      end

      it "sets the date completed" do
        @match.completed_at.should_not == nil
      end
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
