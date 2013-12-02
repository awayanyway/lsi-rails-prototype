class CreateDeviceLocations < ActiveRecord::Migration
  def change
    create_table :device_locations do |t|
      t.integer :device_id
      t.integer :location_id

      t.timestamps
    end
  end
end
