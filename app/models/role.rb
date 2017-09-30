class Role < ApplicationRecord
  has_many :users
  has_many :privileges

  def can_show_internal_candidacies?
    privileges.where(action: 'show_internal', subject: 'candidacy').count > 0
  end

  def can_show_vote_tallies?
    privileges.where(action: 'show_tallies', subject: 'vote').count > 0
  end

  def can_enter_votes?
    privileges.where(action: 'enter', subject: 'vote').count > 0
  end

  def can_delete_votes?
    privileges.where(action: 'delete', subject: 'vote').count > 0
  end

  def can_view_members?
    privileges.where(action: 'view', subject: 'member').count > 0
  end
end