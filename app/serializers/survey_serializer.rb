class SurveySerializer < ActiveModel::Serializer
  attributes :id, :code, :contents, :name, :status
end
