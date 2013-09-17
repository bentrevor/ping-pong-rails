class TeamsController < ApplicationController
  def create
    @team = Team.new

    team_params[:names].each do |name|
      player = Player.find_by_name(name) || Player.create({:name => name})

      @team.players << player
    end

    @team.save
  end

  private

  def team_params
    params.require(:team).permit(:names => [])
  end
end
