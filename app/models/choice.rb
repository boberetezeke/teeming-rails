class Choice < ApplicationRecord
  belongs_to :question

  default_scope ->{ order('order_index asc') }
end