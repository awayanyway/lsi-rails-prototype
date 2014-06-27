class AddRecordedEndAtToMeasurement < ActiveRecord::Migration
  def change
    add_column :measurements, :recorded_end_at, :datetime
  end
end
