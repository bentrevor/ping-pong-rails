class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
  end

  private
  def game_params
    params.require(:game).permit(:player1_id, :player2_id)
  end
end
