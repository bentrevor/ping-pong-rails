require 'spec_helper'
require_relative '../../app/controllers/matches_controller'

describe MatchesController, :type => :controller do
  describe "index" do
    it "assigns an instance variable to show in the view" do
      get :index
      matches = assigns(:matches)

      matches.should_not == nil
    end
  end
end
