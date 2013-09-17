require 'spec_helper'

describe "Game pages" do
  before :each do
    player1 = Player.create({:name => "player1"})
    player2 = Player.create({:name => "player2"})
    team1 = Team.new
    team2 = Team.new
    match = Match.new
    team1.players << player1
    team2.players << player2
    match.teams << team1
    match.teams << team2
    match.save
  end

  it "can view a game" do
    game = Game.create({:match_id => Match.first.id})

    visit "/games/#{game.id}"

    page.body.should have_content 'player1 vs. player2'
  end

  it "can edit a game" do
    game = Game.create({:match_id => Match.first.id})

    visit "/games/#{game.id}/edit"

    fill_in :game_team_1_score, :with => 5
    fill_in :game_team_2_score, :with => 11

    click_on "Submit"

    visit "/games/#{game.id}"

    page.body.should have_content 'player1 vs. player2'
    page.body.should have_content '5'
    page.body.should have_content '11'
  end
end
