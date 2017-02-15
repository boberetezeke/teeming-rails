class SurveyAnswerSerializer < ActiveModel::Serializer
  attributes :id, :contents

  belongs_to :member_id
  belongs_to :survey_id
end
