class Race < ApplicationRecord
  belongs_to :election
  has_many :candidacies
  has_one  :questionnaire, as: :questionnairable

  scope :active_for_time, ->(time){ where(Race.arel_table[:entry_deadline].gt(time) ) }
end