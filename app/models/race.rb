class Race < ApplicationRecord
  belongs_to :election
  has_many :candidacies, dependent: :destroy
  has_one  :questionnaire, as: :questionnairable

  scope :active_for_time, ->(time){ where(Race.arel_table[:entry_deadline].gt(time) ) }

  def candidates_announced?
    candidates_announcement_date &&
       candidates_announcement_date < Time.now
  end
end