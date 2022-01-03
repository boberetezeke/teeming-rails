class Contactor < ApplicationRecord
  belongs_to :account

  belongs_to :user
  belongs_to :contact_bank
end