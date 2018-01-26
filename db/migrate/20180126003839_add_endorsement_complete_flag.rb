class AddEndorsementCompleteFlag < ActiveRecord::Migration[5.0]
  def change
    add_column :races, :endorsement_complete, :boolean
  end
end
