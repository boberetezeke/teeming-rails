class AddImporter < ActiveRecord::Migration[5.2]
  def change
    create_table :importers do |t|
      t.references :user, index: true
      t.string :filename
      t.string :original_filename
      t.string :content_type
      t.timestamps
    end
  end
end
