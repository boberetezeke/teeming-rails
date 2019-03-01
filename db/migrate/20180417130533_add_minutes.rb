class AddMinutes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.timestamps
      t.string :type
      t.references :user, index: true
      t.references :chapter, index: true
      t.string :title
      t.text :body
      t.datetime :published_at
    end
  end
end
