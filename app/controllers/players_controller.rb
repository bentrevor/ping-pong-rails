require 'app/models/player'

class PlayersController < ApplicationController
  def index
    @players = Player.all
  end

  def new
    @player = Player.new
  end

  def create
    Player.create({:name => params[:player][:name]})
  end
end
