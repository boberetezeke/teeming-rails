class ContactAttempt < ApplicationRecord
  belongs_to :contact_bank
  belongs_to :member
end