class Choice < ApplicationRecord
  belongs_to :question

  default_scope ->{ order('order_index asc') }

  def copy
    new_choice = self.dup
    new_choice.save

    new_choice
  end
end