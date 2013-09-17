require 'spec_helper'

describe "Match pages" do
  describe "in_progress page" do
    it "redirects to waiting_list when no in-progress matches" do
      visit '/matches/in_progress'

      current_path.should == '/matches/waiting_list'
    end

    it "shows the currently in_progress match" do
      create_match_between 'player1', 'player2'
      match = Match.first
      match.update_attributes({:in_progress => true})
      match.games[0].update_attributes({:team_1_score => 11, :team_2_score => 5})

      visit '/matches/in_progress'

      page.body.should have_content 'player1 vs. player2'
      page.body.should have_content '11'
      page.body.should have_content '5'
    end
  end

  it "redirects the root path to the waiting list" do
    visit '/'

    current_path.should == '/matches/waiting_list'
  end

  it "creates teams when a match is made" do
    visit '/matches/new'

    fill_in :player_1_name, :with => 'first player'
    fill_in :player_2_name, :with => 'second player'
    click_on 'Submit'

    Match.count.should == 1
    Team.count.should == 2
  end

  describe "listing matches" do
    before :each do
      add_players 'player1',
                  'player2',
                  'player3',
                  'player4'

      create_match_between 'player1', 'player2'
      create_match_between 'player3', 'player4'
    end

    it "can list all matches with scores" do
      visit '/matches'

      match = Match.last

      visit "/matches/#{match.id}/edit"

      fill_in :score_1, :with => 111111
      fill_in :score_2, :with => 222222
      fill_in :score_3, :with => 333333
      fill_in :score_4, :with => 444444
      fill_in :score_5, :with => 555555
      fill_in :score_6, :with => 666666

      click_on "Submit"

      visit "/matches"

      page.body.should have_content 'player1 vs. player2'
      page.body.should have_content 'player3 vs. player4'

      page.body.should have_content '111111'
      page.body.should have_content '222222'
      page.body.should have_content '333333'
      page.body.should have_content '444444'
      page.body.should have_content '555555'
      page.body.should have_content '666666'
    end

    it "can list all completed matches" do
      match = Match.first
      match.completed = true
      match.completed_at = "2013-09-17 15:57:45 UTC"
      match.save

      visit '/matches/finished'

      page.body.should have_content 'player1 vs. player2'
      page.body.should have_content "2013-09-17 15:57:45 UTC"
      page.body.should_not have_content 'player3 vs. player4'
    end

    it "can list all incomplete matches" do
      match = Match.first
      match.completed = true
      match.save

      visit '/matches/waiting_list'

      page.body.should_not have_content 'player1 vs. player2'
      page.body.should have_content 'player3 vs. player4'
    end

    it "doesn't show in-progress matches on the waiting_list page" do
      match = Match.first
      match.in_progress = true
      match.save

      visit '/matches/waiting_list'

      page.body.should_not have_content 'player1 vs. player2'
      page.body.should have_content 'player3 vs. player4'
    end

    describe "links" do
      before :each do
        add_players 'player1',
                    'player2'

        create_match_between 'player1', 'player2'
      end

      it "has a link to start a match" do
        match = Match.first

        visit '/matches/waiting_list'

        page.body.should have_link 'Start match', :href => "/matches/#{match.id}/start"
      end

      it "has a link to sign up for a match" do
        visit '/matches'
        page.body.should have_link 'Create match', :href => '/matches/new'

        visit '/matches/finished'
        page.body.should have_link 'Create match', :href => '/matches/new'

        visit '/matches/waiting_list'
        page.body.should have_link 'Create match', :href => '/matches/new'
      end

      it "has a link to delete a match" do
        match = Match.first

        visit '/matches/waiting_list'

        page.body.should have_link 'Delete match', :href => "/matches/#{match.id}"
      end

      it "has a link to show a match" do
        match = Match.first

        visit '/matches'
        page.body.should have_link 'Show match', :href => "/matches/#{match.id}"
      end

    end
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

  it "can show doubles teams" do
    add_players 'player1',
                'player2',
                'player3',
                'player4'

    visit '/matches/new'

    fill_in :player_1_name, :with => 'player1'
    fill_in :player_2_name, :with => 'player2'
    fill_in :player_3_name, :with => 'player3'
    fill_in :player_4_name, :with => 'player4'

    click_on 'Submit'

    match = Match.first
    visit "/matches/#{match.id}"

    page.body.should have_content 'player1'
    page.body.should have_content 'player2'
    page.body.should have_content 'player3'
    page.body.should have_content 'player4'
  end

  it "can enter scores for a match from the browser" do
    add_players 'player1',
                'player2'

    create_match_between 'player1', 'player2'

    match = Match.last

    visit "/matches/#{match.id}/edit"

    fill_in :score_1, :with => 111111
    fill_in :score_2, :with => 222222
    fill_in :score_3, :with => 333333
    fill_in :score_4, :with => 444444
    fill_in :score_5, :with => 555555
    fill_in :score_6, :with => 666666

    click_on "Submit"

    visit "/matches/#{match.id}"

    page.body.should have_content '111111'
    page.body.should have_content '222222'
    page.body.should have_content '333333'
    page.body.should have_content '444444'
    page.body.should have_content '555555'
    page.body.should have_content '666666'
  end

  it "lists all four players names for doubles" do
    visit '/matches/new'

    fill_in :player_1_name, :with => 'player1'
    fill_in :player_2_name, :with => 'player2'
    fill_in :player_3_name, :with => 'player3'
    fill_in :player_4_name, :with => 'player4'

    click_on 'Submit'

    visit '/matches/waiting_list'

    page.body.should have_content 'player1'
    page.body.should have_content 'player2'
    page.body.should have_content 'player3'
    page.body.should have_content 'player4'
  end

  private

  def create_match_between(first_player, second_player)
    visit '/matches/new'

    fill_in :player_1_name, :with => first_player
    fill_in :player_2_name, :with => second_player

    click_on 'Submit'
  end
end
