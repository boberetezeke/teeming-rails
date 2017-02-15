class CandidateSerializer < ActiveModel::Serializer
  attributes :id, :name, :office, :questions, :slug

  def slug
    object.name.parameterize
  end
end
