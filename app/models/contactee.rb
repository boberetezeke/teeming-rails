class Contactee < ApplicationRecord
  belongs_to :member
  belongs_to :contact_bank
end