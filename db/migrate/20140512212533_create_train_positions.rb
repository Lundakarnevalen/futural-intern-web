class CreateTrainPositions < ActiveRecord::Migration
  def change
    create_table :train_positions do |t|
      t.float :lat
      t.float :lng
    end
  end
end
