class MatchesController < ApplicationController
  def index
    @matches = Match.all
    @page_title = "All Matches"
  end

  def show
    @match = Match.find(params[:id])
    @page_title = "Match ##{@match.id}"
    @winning_team = Team.find(@match.winner) if @match.winner
  end

  def waiting_list
    @matches = Match.where(:completed => false, :in_progress => false)
    @page_title = "Waiting List"
  end

  def finished
    @matches = Match.where(:completed => true)
    @page_title = "Finished Matches"
  end

  def in_progress
    @in_progress = Match.where(:in_progress => true).first

    redirect_to(:action => :waiting_list) unless @in_progress
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

    @match.games[0].update_attributes(match_params[:game1])
    @match.games[1].update_attributes(match_params[:game2])
    @match.games[2].update_attributes(match_params[:game3])

    redirect_to @match
  end

  def finish
    @match = Match.find params[:id]

    @match.update_attributes({:in_progress => false,
                              :completed => true,
                              :completed_at => Time.now })

    winning_team = winner_of @match
    @match.update_attributes({:winner => winning_team.id}) if winning_team

    redirect_to @match
  end

  def start
    @match = Match.find params[:id]

    if no_in_progress_matches?
      @match.update_attributes({:in_progress => true})
    end

    redirect_to :action => :in_progress
  end

  def create
    @match = Match.new

    teams_from_params.each do |team|
      @match.teams << team
    end

    @match.completed = match_params[:completed] || false
    @match.number_of_games = match_params[:number_of_games]
    @match.save

    redirect_to :action => :waiting_list
  end

  def destroy
    Match.find(params[:id]).destroy
    redirect_to :action => :waiting_list
  end

  private

  def match_params
    params.require(:match).permit(:completed,
                                  :number_of_games,
                                  :names => [],
                                  :game1 => [:team_1_score, :team_2_score],
                                  :game2 => [:team_1_score, :team_2_score],
                                  :game3 => [:team_1_score, :team_2_score])
  end

  def winner_of(match)
    team_1_wins = 0
    team_2_wins = 0

    match.games.each do |game|
      if game.team_1_score and game.team_2_score
        if game.team_1_score > game.team_2_score
          team_1_wins += 1
        else
          team_2_wins += 1
        end
      end
    end

    victory_threshold = match.number_of_games / 2

    if team_1_wins > victory_threshold
      match.teams.first
    elsif team_2_wins > victory_threshold
      match.teams.last
    end
  end

  def no_in_progress_matches?
    Match.all.each do |match|
      if match.in_progress
        return false
      end
    end

    true
  end

  def teams_from_params
    teams = []
    names = match_params[:names].reject { |name| name == '' }

    if names.length == 2
      names.each do |name|
        team = Team.new
        player = Player.find_by_name(name) || Player.create({:name => name})

        team.players << player
        teams << team
      end
    elsif names.length == 4
      team1 = Team.new
      team2 = Team.new
      player1 = Player.find_by_name(names[0]) || Player.create({:name => names[0]})
      player2 = Player.find_by_name(names[1]) || Player.create({:name => names[1]})
      player3 = Player.find_by_name(names[2]) || Player.create({:name => names[2]})
      player4 = Player.find_by_name(names[3]) || Player.create({:name => names[3]})

      team1.players << player1
      team1.players << player2
      team2.players << player3
      team2.players << player4

      teams << team1
      teams << team2
    end

    teams
  end
end
