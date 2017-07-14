class ChangeOrderForChoices < ActiveRecord::Migration[5.0]
  def change
    rename_column :choices, :order, :order_index
  end
end
