class CreateStorlekar < ActiveRecord::Migration
  def change
    create_table :storlekar do |t|
      t.string :name, :null => false
    end
  end
end
