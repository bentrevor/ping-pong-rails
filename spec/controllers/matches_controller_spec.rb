require 'spec_helper'
require 'app/controllers/matches_controller'
require 'pp'

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

    context "errors" do
      it "fails when given only one player name" do
        post :create, :match => {:names => ["name 1"]}

        Match.count.should == 0
        flash[:notice].should == 'Please enter two or four player names.'
        response.should redirect_to('/matches/new')
      end

      it "fails when given three player names" do
        post :create, :match => {:names => ["name 1", "name 2", "name 3"]}

        Match.count.should == 0
        flash[:notice].should == 'Please enter two or four player names.'
        response.should redirect_to('/matches/new')
      end

      it "shows a flash message when there is no in-progress match" do
        post :create, :match => {:names => ["name 1", "name 2"]}

        get :in_progress, :id => Match.first.id
        flash[:notice].should == 'There is no match in progress.'
        response.should redirect_to('/matches/waiting_list')
      end
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
      it "redirects (with a flash message) to waiting list after creation" do
        post :create, :match => {:names => ["name 1", "name 2"], :number_of_games => 3}

        response.should redirect_to('/matches/waiting_list')
        flash[:notice].should == "Match created successfully."
      end

      it "redirects (with a flash message) to waiting list after destruction" do
        post :create, :match => {:names => ["name 1", "name 2"], :number_of_games => 3}

        delete :destroy, :id => Match.first.id

        response.should redirect_to('/matches/waiting_list')
        flash[:notice].should == "Match has been deleted."
      end

      it "redirects to current match after updating" do
        post :create, :match => {:names => ["name 1", "name 2"], :number_of_games => 3}
        id = Match.first.id
        post :start, :id => id
        post :update, :id => id, :match =>
                                             {:game1 => {:team_1_score => 1, :team_2_score => 2},
                                              :game2 => {:team_1_score => 3, :team_2_score => 4},
                                              :game3 => {:team_1_score => 5, :team_2_score => 6}}

        response.should redirect_to("/matches/in_progress")
      end

      context "for failures" do
        it "redirects with flash message when trying to start a second match" do
          create_three_matches
          post :start, :id => Match.first.id
          post :start, :id => Match.last.id

          response.should redirect_to('/matches/waiting_list')
          flash[:notice].should == 'A match is already in progress.'
        end
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
      post :start, :id => Match.first.id
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
        id = Match.first.id
        post :start, :id => id
        post :update, :id => id, :match =>
                                   {:game1 => {:team_1_score => 11, :team_2_score => 2},
                                    :game2 => {:team_1_score => 11, :team_2_score => 4},
                                    :game3 => {:team_1_score => 11, :team_2_score => 6}}

        post :finish, :id => id
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

  context "flash messages" do
    it "sets a flash message when there's no current match" do
      create_three_matches

      get :in_progress

      flash[:notice].should == "There is no match in progress."
    end
  end

  context "json api" do
    before :each do
      request.accept = 'application/json'
      post :create, :match => {:names => ["player1 name", "player2 name"]}
    end

    it "can create a match" do
      json_response = JSON.parse response.body

      json_response['Status'].should == "OK"
    end

    it "can show a match" do
      get :show, :id => Match.first.id

      json_response = JSON.parse response.body

      json_response['match']['id'].should == Match.first.id
      json_response['players'][0]['name'].should == 'player1 name'
      json_response['players'][1]['name'].should == 'player2 name'
    end

    it "can show the in-progress match" do
      post :start, :id => Match.first.id
      get :in_progress

      json_response = JSON.parse response.body

      json_response['match']['id'].should == Match.first.id
      json_response['players'][0]['name'].should == 'player1 name'
      json_response['players'][1]['name'].should == 'player2 name'
    end

    it "can start a match" do
      Match.first.in_progress.should == false
      post :start, :id => Match.first.id

      json_response = JSON.parse response.body

      json_response['match']['in_progress'].should == true
    end

    it "can finish a match" do
      match = Match.first
      post :start, :id => match.id
      post :update, :id => match.id, :match =>
                                           {:game1 => {:team_1_score => 1, :team_2_score => 2},
                                            :game2 => {:team_1_score => 3, :team_2_score => 4},
                                            :game3 => {:team_1_score => 5, :team_2_score => 6}}

      json_response = JSON.parse response.body

      match.reload
      match.completed.should == true
      match.in_progress.should == false
      match.games[0].team_1_score.should == 1
      match.games[0].team_2_score.should == 2
    end

    context "listing matches" do
      before :each do
        create_three_matches
        create_four_completed_matches
      end

      it "can get a list of all matches" do
        get :index

        json_response = JSON.parse response.body

        json_response['matches'].length.should == 8
        json_response['matches'].first['id'].should == Match.first.id
      end

      it "can show all waiting list matches" do
        get :waiting_list

        json_response = JSON.parse response.body

        json_response['matches'].length.should == 4
        json_response['matches'].each do |match|
          match['completed'].should == false
        end
      end

      it "can get a list of all finished matches with scores and players" do
        get :finished

        json_response = JSON.parse response.body

        json_response['matches'].length.should == 4
        json_response['matches'].each do |match|
          match['completed'].should == true
        end
        json_response['scores'].should_not == nil
        json_response['players'].should_not == nil
      end

      it "returns scores for completed matches in the index" do
        create_three_matches
        post :start, :id => Match.last.id
        post :update, :id => Match.last.id, :match =>
                                              {:game1 => {:team_1_score => 1, :team_2_score => 2}}
        get :index

        json_response = JSON.parse response.body

        json_response['matches'].first['completed'].should == false
        json_response['matches'].first['games'].should == nil

        json_response['matches'].last['completed'].should == true
        json_response['scores'][Match.last.id.to_s][0]['team_1_score.should'] == 1
        json_response['scores'][Match.last.id.to_s][0]['team_2_score.should'] == 2
      end
    end

    context "errors" do
      it "requires two player names" do
        post :create, :match => {:names => ["player3 name"]}

        json_response = JSON.parse response.body

        json_response['error'].should == 'Please enter two or four player names.'
      end

      it "can only start one match at a time" do
        post :create, :match => {:names => ["player3 name", "player4 name"]}
        post :start, :id => Match.first.id
        post :start, :id => Match.last.id

        json_response = JSON.parse response.body

        Match.last.in_progress.should == false
        json_response['error'].should == 'A match is already in progress.'
      end

      it "can't update scores for games that aren't in progress" do
        post :update, :id => Match.first.id, :match =>
                                               {:game1 => {:team_1_score => 1, :team_2_score => 2},
                                                :game2 => {:team_1_score => 3, :team_2_score => 4},
                                                :game3 => {:team_1_score => 5, :team_2_score => 6}}

        json_response = JSON.parse response.body
        Match.first.games[0].team_1_score.should == 0
        json_response['error'].should == 'You must start a match before updating its scores.'
      end

      it "returns error when no match is in progress" do
        get :in_progress, :id => Match.first.id

        json_response = JSON.parse response.body

        json_response['error'].should == 'There is no match in progress.'
      end
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
