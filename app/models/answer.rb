class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :candidacy

  default_scope ->{ order('order_index asc') }
end