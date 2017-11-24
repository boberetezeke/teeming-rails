class MessageRecipient < ApplicationRecord
  belongs_to :message
  belongs_to :member
  belongs_to :candidacy
end
