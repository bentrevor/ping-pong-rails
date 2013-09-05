class Game < ActiveRecord::Base
  validates :player1_id, :presence => true
  validates :player2_id, :presence => true

  validate  :no_duplicate_ids, :two_or_four_players

  private

  def no_duplicate_ids
    ids = [player1_id,
           player2_id,
           player3_id,
           player4_id].compact

    if ids.uniq.length != ids.length
      errors.add(:duplicate_id, "two players have the same id")
    end
  end

  def two_or_four_players
    if (player3_id and !player4_id) or (!player3_id and player4_id)
      errors.add(:wrong_number_of_players, "must have two or four players")
    end
  end
end
