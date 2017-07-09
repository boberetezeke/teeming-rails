class AddOrderToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :order_index, :integer
    rename_column :questions, :order, :order_index
    rename_column :questionnaire_sections, :order, :order_index
  end
end
