class AddSampleToMeasurement < ActiveRecord::Migration
  def change
    add_column :measurements, :sample_id, :integer
  end
end
