class AddUnlockRequestedToCandidacies < ActiveRecord::Migration[5.0]
  def change
    add_column :candidacies, :unlock_requested_at, :datetime
  end
end
