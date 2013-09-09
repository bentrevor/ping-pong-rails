class MatchesController < ApplicationController
  def index
    @matches = Match.all
  end

  def show
    @match = Match.find(params[:id])
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
    @match = Match.new

    match_params[:names].each do |name|
      player = Player.find_by_name(name) || Player.create({:name => name})

      @match.players << player
    end

    @match.completed = match_params[:completed] || false
    @match.save
  end

  private
  def match_params
    params.require(:match).permit(:completed, :names => [])
  end
end
