class OfficerAssignment < ApplicationRecord
  belongs_to :officer
  belongs_to :user
end