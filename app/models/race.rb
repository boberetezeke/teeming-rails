class Race < ApplicationRecord
  belongs_to :election
  has_many :candidacies, dependent: :destroy
  has_one  :questionnaire, as: :questionnairable

  validates :name, presence: true

  scope :active_for_time, ->(time){ where(Race.arel_table[:filing_deadline_date].gt(time) ) }

  def candidates_announced?
    candidates_announcement_date &&
       candidates_announcement_date < Time.now
  end
end