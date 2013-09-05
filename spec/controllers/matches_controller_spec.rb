require 'spec_helper'
require 'app/controllers/matches_controller'

describe MatchesController do
  it "can create a match without saving it" do
    get :new
    match = assigns(:match)

    Match.count.should == 0
    match.should_not == nil
    match.game1_id.should == nil
  end

  it "can save a match" do
    post :create, :match => {:game1_id => 1, 
                             :game2_id => 2}
    match = assigns(:match)

    Match.count.should == 1
  end

  context "showing all matches" do
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
    Match.create({:game1_id => 1, :game2_id => 2})
    Match.create({:game1_id => 3, :game2_id => 4})
    Match.create({:game1_id => 5, :game2_id => 6})
  end

  def create_four_completed_matches
    Match.create({:game1_id => 1, :game2_id => 2, :completed => true})
    Match.create({:game1_id => 3, :game2_id => 4, :completed => true})
    Match.create({:game1_id => 5, :game2_id => 6, :completed => true})
    Match.create({:game1_id => 7, :game2_id => 8, :completed => true})
  end
end
