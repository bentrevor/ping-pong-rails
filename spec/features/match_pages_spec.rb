require 'spec_helper'

describe "Match pages" do
  it "can create a match through the form" do
    visit '/matches/new'

    fill_in :player_1_name, :with => 'first player'
    fill_in :player_2_name, :with => 'second player'
    click_on 'Submit'

    Match.count.should == 1
  end

  it "can list all matches" do
    add_players 'player1',
                'player2',
                'player3',
                'player4',
                'player5',
                'player6'

    create_match_between 'player1', 'player2'
    create_match_between 'player3', 'player4'
    create_match_between 'player5', 'player6'

    visit '/matches'

    page.body.should have_content 'player1 vs. player2'
    page.body.should have_content 'player3 vs. player4'
    page.body.should have_content 'player5 vs. player6'
  end

  it "can list all completed matches" do
    add_players 'player1',
                'player2',
                'player3',
                'player4'

    create_match_between 'player1', 'player2'
    create_match_between 'player3', 'player4'

    match = Match.first
    match.completed = true
    match.save

    visit '/matches/finished'

    page.body.should have_content 'player1 vs. player2'
    page.body.should_not have_content 'player3 vs. player4'
  end

  it "can list all incomplete matches" do
    add_players 'player1',
                'player2',
                'player3',
                'player4'

    create_match_between 'player1', 'player2'
    create_match_between 'player3', 'player4'

    match = Match.first
    match.completed = true
    match.save

    visit '/matches/waiting_list'

    page.body.should_not have_content 'player1 vs. player2'
    page.body.should have_content 'player3 vs. player4'
  end

  it "can show an individual match" do
    add_players 'player1',
                'player2'

    create_match_between 'player1', 'player2'

    match = Match.first
    match.games[0].update_attributes({:team_1_score => 11, :team_2_score => 5})

    visit '/matches/1'

    page.body.should have_content 'player1 vs. player2'
    page.body.should have_content '11'
    page.body.should have_content '5'
  end

  it "can enter scores for a match from the browser" do
    add_players 'player1',
                'player2'

    create_match_between 'player1', 'player2'

    match = Match.last

    visit "/matches/#{match.id}/edit"

    fill_in :score_1, :with => 1
    fill_in :score_2, :with => 2
    fill_in :score_3, :with => 3
    fill_in :score_4, :with => 4
    fill_in :score_5, :with => 5
    fill_in :score_6, :with => 6

    click_on "Submit"

    visit "/matches/#{match.id}"

    page.body.should have_content 'winner: player2'
  end

  private
  def create_match_between(first_player, second_player)
    visit '/matches/new'

    fill_in :player_1_name, :with => first_player
    fill_in :player_2_name, :with => second_player

    click_on 'Submit'
  end
end
