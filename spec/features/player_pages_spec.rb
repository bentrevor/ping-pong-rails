require 'spec_helper'

describe "Player pages" do
  it "can show all players" do
    add_players 'player1', 'player2'
    visit '/players'

    page.body.should have_content 'player1'
    page.body.should have_content 'player2'
  end

  it "can show a single player" do
    player1 = Player.create({:name => 'player1'})
    player2 = Player.create({:name => 'player2'})

    visit "/players/#{player1.id}"

    page.body.should have_content player1.name
    page.body.should_not have_content player2.name
  end
end
