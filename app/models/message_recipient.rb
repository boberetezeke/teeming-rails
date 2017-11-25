class MessageRecipient < ApplicationRecord
  belongs_to :message
  belongs_to :member
  belongs_to :candidacy

  def name
    forward(:name)
  end

  def email
    forward(:email)
  end

  private

  def forward(sym)
    if candidacy
      candidacy.send(sym)
    else
      member.send(sym)
    end

  end
end
