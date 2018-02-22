class Officer < ApplicationRecord
  belongs_to :chapter
  has_one :officer_assignment
  accepts_nested_attributes_for :officer_assignment
  has_one :user, through: :officer_assignment

  def name
    "#{officer_type} (#{chapter.name})"
  end
end