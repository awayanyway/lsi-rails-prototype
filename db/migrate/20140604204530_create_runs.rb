class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.integer :location_id
      t.integer :measurement_id
      t.integer :user_id
      t.datetime :started_at
      t.datetime :stopped_at
      t.boolean :finished, :default => false

      t.timestamps
    end
  end
end
