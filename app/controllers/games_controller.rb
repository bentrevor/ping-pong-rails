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

  def finish
    @game = Game.find(game_params[:id])

    @game.completed = true
    @game.update_attributes(game_params)
  end

  private
  def game_params
    params.require(:game).permit(:id, :winner_score, :loser_score, :winner, :match_id)
  end
end
