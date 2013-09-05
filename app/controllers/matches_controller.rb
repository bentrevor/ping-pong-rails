class MatchesController < ApplicationController
  def index
    @matches = Match.all
  end

  def waiting_list
    @matches = Match.where(:completed => false)
  end

  def finished
    @matches = Match.where(:completed => true)
  end

  def new
    @match = Match.new
  end

  def create
    @match = Match.create(matches_params)
  end

  private
  def matches_params
    params.require(:match).permit(:game1_id, :game2_id)
  end
end
