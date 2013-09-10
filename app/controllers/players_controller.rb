require 'app/models/player'

class PlayersController < ApplicationController
  def index
    @players = Player.all
    @page_title = "All Players"
  end

  def new
    @player = Player.new
    @page_title = "Create Player"
  end

  def create
    @player = Player.create(player_params)
    redirect_to @player
  end

  def show
    @player = Player.find(params[:id])
  end

  private
  def player_params
    params.require(:player).permit(:name)
  end
end
