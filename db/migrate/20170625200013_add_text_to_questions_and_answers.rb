class AddTextToQuestionsAndAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :text, :text
    add_column :answers, :text, :text
  end
end
