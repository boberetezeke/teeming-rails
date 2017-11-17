class Chapter < ApplicationRecord
  has_many :elections
  has_many :members
  has_many :events

  has_one :skills_questionnaire, as: :questionnairable, class_name: 'Questionnaire'

  scope :local_chapters, ->{ where(is_state_wide: false) }

  def self.state_wide
    Chapter.find_by_is_state_wide(true)
  end
end