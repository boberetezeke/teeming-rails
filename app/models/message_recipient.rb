class MessageRecipient < ApplicationRecord
  belongs_to :message
  belongs_to :member
  belongs_to :candidacy

  before_create :create_token

  def name
    forward(:name)
  end

  def first_name
    forward(:first_name)
  end

  def last_name
    forward(:last_name)
  end

  def email
    forward(:email)
  end

  def email=(email)
    write_attribute(:email, email)
  end

  private

  def create_token
    self.token = SecureRandom.hex(10)
  end

  def forward(sym)
    if read_attribute(:email).present?
      if sym == :name || sym == :first_name
        read_attribute(:email)
      else
        ""
      end
    elsif candidacy
      candidacy.send(sym)
    else
      member.send(sym)
    end
  end
end
