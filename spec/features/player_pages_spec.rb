require 'spec_helper'

describe "Player pages" do
  it "can create a player through the form" do
    visit '/players/new'

    fill_in :player_name, :with => 'Ben'
    click_on 'Submit'

    Player.count.should == 1
  end

  it "shows all players" do
    add_players 'player1', 'player2'
    visit '/players'

    page.body.should have_content 'player1'
    page.body.should have_content 'player2'
  end
end
