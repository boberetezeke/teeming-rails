class AddEventsAndRsvps < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string    :name
      t.text      :description
      t.datetime  :occurs_at
      t.string    :location
      t.float     :longitude
      t.float     :latitude
    end

    create_table :event_rsvps do |t|
      t.references :user
      t.references :event
      t.string     :rsvp_type
    end
  end
end
