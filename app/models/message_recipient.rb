class MessageRecipient < ApplicationRecord
  belongs_to :message
  belongs_to :member
  belongs_to :candidacy

  before_create :create_token

  def name
    forward(:name)
  end

  def email
    forward(:email)
  end

  private

  def create_token
    self.token = SecureRandom.hex(10)
  end

  def forward(sym)
    if candidacy
      candidacy.send(sym)
    else
      member.send(sym)
    end

  end
end
