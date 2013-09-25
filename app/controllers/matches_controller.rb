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
    @in_progress = current_match || (render_no_current_match and return)
    @page_title = "Current Match"

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
    @match = Match.find params[:id]

    if @match.in_progress and update_games_for @match
      respond_with(@match) do |format|
        format.html { redirect_to :action => :in_progress }
        format.json do
          @match.update_attributes({:completed => true,
                                    :in_progress => false})
          return_match_as_json(@match)
        end
      end
    else
      respond_with do |format|
        flash[:notice] = 'You must start a match before updating its scores.'

        format.html { redirect_to :action => :waiting_list }
        format.json { render :json => { 'error' => flash[:notice] }}
      end
    end
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

      respond_with(@match) do |format|
        format.html { redirect_to :action => :in_progress }
        format.json { return_match_as_json(@match) }
      end
    else
      respond_with do |format|
        flash[:notice] = 'A match is already in progress.'

        format.html { redirect_to :action => :waiting_list }
        format.json { render :json => { 'error' => flash[:notice] }}
      end
    end
  end

  def create
    @match = Match.new

    teams_from_params.each do |team|
      @match.teams << team
    end

    @match.completed = match_params[:completed] || false
    @match.number_of_games = match_params[:number_of_games]
    if @match.save
      flash[:notice] = "Match created successfully."

      respond_with(@match) do |format|
        format.html { redirect_to :action => :waiting_list }
        format.json { render :json => { 'Status' => 'OK' }}
      end
    else
      respond_with do |format|
        flash[:notice] = 'Please enter two or four player names.'

        format.html { redirect_to :action => :new }
        format.json { render :json => { 'error' => flash[:notice] }}
      end
    end
  end

  def destroy
    Match.find(params[:id]).destroy
    flash[:notice] = "Match has been deleted."
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

  def update_games_for(match)
    match.games[0].update_attributes(match_params[:game1])
    match.games[1].update_attributes(match_params[:game2])
    match.games[2].update_attributes(match_params[:game3])
  end

  def pending_matches
    Match.where(:completed => false, :in_progress => false)
  end

  def render_list_of(matches)
    respond_with(@matches) do |format|
      format.html
      format.json { return_matches_as_json(@matches) }
    end
  end

  def render_single(match)
    respond_with(@match) do |format|
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

  def render_no_current_match
    flash[:notice] = 'There is no match in progress.'

    respond_with(@in_progress) do |format|
      format.html { redirect_to(:action => :waiting_list) }
      format.json { render :json => { 'error' => flash[:notice] }}
    end
  end
end
