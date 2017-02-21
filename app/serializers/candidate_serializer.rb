class CandidateSerializer < ActiveModel::Serializer
  attributes :id, :code, :links, :name, :office, :questions
end
