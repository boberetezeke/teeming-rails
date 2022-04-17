class AddWhenToMeetSlug < ActiveRecord::Migration[5.2]
  def change
    add_column :when_to_meets, :slug, :string
  end
end
