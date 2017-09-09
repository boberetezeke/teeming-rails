class Role < ApplicationRecord
  belongs_to :user
  has_many :privileges

  def can_show_internal_races?
    privileges.where(subject: 'race', action: 'show').count > 0
  end
end