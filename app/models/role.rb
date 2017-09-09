class Role < ApplicationRecord
  has_many :users
  has_many :privileges

  def can_show_internal_candidacies?
    privileges.where(action: 'show_internal', subject: 'candidacy').count > 0
  end
end