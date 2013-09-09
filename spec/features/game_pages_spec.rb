require 'spec_helper'

describe "Game pages" do
  it "can view a game" do
    player1 = Player.create({:name => "player1"})
    player2 = Player.create({:name => "player2"})
    match = Match.new
    match.players << player1
    match.players << player2

    match.save

    Game.create({:match_id => match.id})

    visit '/games/1'

    page.body.should have_content 'player1 vs. player2'
  end

  it "can edit a game" do
    player1 = Player.create({:name => "player1"})
    player2 = Player.create({:name => "player2"})
    match = Match.new
    match.players << player1
    match.players << player2

    match.save

    Game.create({:match_id => match.id})

    visit '/games/1/edit'

    fill_in :game_team_1_score, :with => 5
    fill_in :game_team_2_score, :with => 11

    click_on "Submit"

    visit '/games/1'

    page.body.should have_content 'player1 vs. player2'
    page.body.should have_content '5'
    page.body.should have_content '11'
  end
end
