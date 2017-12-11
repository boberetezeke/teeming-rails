class Privilege < ApplicationRecord
  belongs_to :role

  def parsed_scope
    if scope.nil?
      {}
    else
      JSON.parse(scope)
    end
  end
end