class SurveyAnswer < ApplicationRecord
  belongs_to :member
  belongs_to :survey
end
