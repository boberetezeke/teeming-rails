class Privilege < ApplicationRecord
  belongs_to :account

  belongs_to :role

  def is_identical_to?(other)
    to_hash == other.to_hash
  end

  def to_hash
    {subject: subject, action: action, parsed_scope: parsed_scope}
  end

  def parsed_scope
    if scope.nil?
      {}
    else
      JSON.parse(scope)
    end
  end
end