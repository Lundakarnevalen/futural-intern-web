class CreateClusters < ActiveRecord::Migration
  def change
    create_table :clusters do |t|
      t.float :lat
      t.float :lng
      t.integer :quantity, default: 1
      t.timestamps
    end
    add_index :clusters, [:lat, :lng]
  end
end
