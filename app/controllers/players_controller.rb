require 'app/models/player'

class PlayersController < ApplicationController
  def create
    Player.create({:name => params[:name]})
  end
end
