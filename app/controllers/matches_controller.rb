class MatchesController < ApplicationController
  def index
    @matches = Match.all
    @page_title = "All Matches"
  end

  def show
    @match = Match.find(params[:id])
    @page_title = "Match ##{@match.id}"
    @winner = winner_of @match
  end

  def waiting_list
    @matches = Match.where(:completed => false)
    @page_title = "Waiting List"
  end

  def finished
    @matches = Match.where(:completed => true)
    @page_title = "Finished Matches"
  end

  def new
    @match = Match.new
    @page_title = "Create new match"
  end

  def edit
    @match = Match.find(params[:id])
    @page_title = "Edit match"
  end

  def update
    @match = Match.find params[:id]
    @match.update_attributes({:completed => true})

    @match.games[0].update_attributes(match_params[:game1])
    @match.games[1].update_attributes(match_params[:game2])
    @match.games[2].update_attributes(match_params[:game3])
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

  def destroy
    Match.find(params[:id]).destroy
  end

  private
  def match_params
    params.require(:match).permit(:completed, :names => [],
                                  :game1 => [:team_1_score, :team_2_score],
                                  :game2 => [:team_1_score, :team_2_score],
                                  :game3 => [:team_1_score, :team_2_score])
  end

  def winner_of(match)
    team_1_wins = 0
    team_2_wins = 0

    match.games.each do |game|
      if game.team_1_score > game.team_2_score
        team_1_wins += 1
      else
        team_2_wins += 1
      end
    end

    if team_1_wins > team_2_wins
      match.players[0].name
    else
      match.players[1].name
    end
  end
end
