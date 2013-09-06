require 'spec_helper'

describe "Match pages" do
  it "can create a match through the form" do
    visit '/matches/new'

    fill_in :player_1_name, :with => 'first player'
    fill_in :player_2_name, :with => 'second player'
    click_on 'Submit'

    Match.count.should == 1
  end
end
