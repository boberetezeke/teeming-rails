require 'csv'

class Member < ApplicationRecord
  validates :databank_id, presence: true, uniqueness: true

  scope :valid_email, -> {
    where(
      '(status != ? AND status != ? AND status != ? AND status != ?)',
      'invalid', 'bounce', 'block', 'unsubscribe'
    )
  }

  scope :active, -> {
    where(status: 'active')
  }

  def self.to_csv
    attributes = Member.attribute_names

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |member|
        csv << attributes.map{ |attr| member.send(attr) }
      end
    end
  end
end
