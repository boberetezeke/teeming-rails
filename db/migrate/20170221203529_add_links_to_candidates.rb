class AddLinksToCandidates < ActiveRecord::Migration[5.0]
  def change
    add_column :candidates, :links, :text, array: true
  end
end
