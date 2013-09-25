class MatchesController < ApplicationController
  respond_to :html, :json

  def index
    @matches = Match.all
    @page_title = "All Matches"

    render_list_of @matches
  end

  def waiting_list
    @matches = pending_matches
    @page_title = "Waiting List"

    render_list_of @matches
  end

  def show
    @match = Match.find_by_id(params[:id]) || (render_404 and return)
    @page_title = "Match ##{@match.id}"
    @winning_team = Team.find(@match.winner) if @match.winner

    render_single @match
  end

  def finished
    @matches = Match.where(:completed => true)
    @page_title = "Finished Matches"

    render_list_of @matches
  end

  def in_progress
    @in_progress = current_match
    @page_title = "Current Match"

    return redirect_with_error(:waiting_list, 'There is no match in progress.') unless @in_progress

    render_single @in_progress
  end

  def new
    @match = Match.new
    @page_title = "Create new match"
  end

  def edit
    @match = Match.find_by_id(params[:id]) || (render_404 and return)
    @page_title = "Edit match"
  end

  def update
    @match = Match.find_by_id(params[:id]) || (render_404 and return)

    return redirect_with_error(:in_progress, 'You must start a match before updating its scores.') unless ready_to_update @match

    respond_to do |format|
      format.html { redirect_to :action => :in_progress }

      format.json do
        finalize @match
        return_match_as_json(@match)
      end
    end
  end

  def finish
    @match = Match.find_by_id(params[:id]) || (render_404 and return)

    finalize @match

    redirect_to @match
  end

  def start
    @match = Match.find_by_id(params[:id]) || (render_404 and return)

    return redirect_with_error(:waiting_list,
                               'A match is already in progress.') if any_match_already_in_progress?

    @match.update_attributes({:in_progress => true})
    redirect_with_success :in_progress
  end

  def create
    @match = Match.new

    teams_from_params.each do |team|
      @match.teams << team
    end

    @match.number_of_games = match_params[:number_of_games]

    return redirect_with_error(:new, 'Please enter two or four player names.') unless @match.save

    redirect_with_success :waiting_list, 'Match created successfully.'
  end

  def destroy
    Match.find(params[:id]).destroy
    flash[:notice] = "Match has been deleted."
    redirect_to :action => :waiting_list
  end

  private

  def match_params
    params.require(:match).permit(:number_of_games,
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

  def any_match_already_in_progress?
    Match.all.any? { |match| match.in_progress }
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

  def return_match_as_json(match)
    render :json => { :match => match,
                      :players => match.players }
  end

  def return_matches_as_json(matches)
    scores = {}
    players = {}

    matches.each do |match|
      scores[match.id] = match.games if match['completed']
      players[match.id] = match.players
    end

    render :json => { :matches => matches,
                      :scores => scores,
                      :players => players }
  end

  def pending_matches
    Match.where(:completed => false, :in_progress => false)
  end

  def render_list_of(matches)
    respond_to do |format|
      format.html
      format.json { return_matches_as_json(@matches) }
    end
  end

  def render_single(match)
    respond_to do |format|
      format.html
      format.json { return_match_as_json(@match) }
    end
  end

  def render_404
    respond_to do |format|
      format.html do
        @page_title = 'Oops!'
        render :file => "#{Rails.root}/public/404.html",
               :status => 404
      end

      format.json { render :json => { 'error' => 'No match exists with that id.' }}
    end
  end

  def current_match
    Match.where(:in_progress => true).first
  end

  def finalize(match)
    match.update_attributes({:in_progress => false,
                             :completed => true,
                             :completed_at => Time.now })

    winning_team = winner_of @match
    @match.update_attributes({:winner => winning_team.id}) if winning_team
  end

  def ready_to_update(match)
    match.in_progress and update_games_for(match)
  end

  def update_games_for(match)
    match.games.each_with_index do |game, index|
      match.games[index].update_attributes(match_params["game#{index + 1}".to_sym])
    end
  end

  def redirect_with_success(action, message=nil)
    flash[:notice] = message if message

    respond_to do |format|
      format.html { redirect_to :action => action }
      format.json { render :json => { 'Status' => 'OK' }}
    end
  end

  def redirect_with_error(action, error)
    flash[:notice] = error

    respond_to do |format|
      format.html { redirect_to(:action => action) }
      format.json { render :json => { 'error' => flash[:notice] }}
    end
  end
end
