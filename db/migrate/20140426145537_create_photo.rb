class CreatePhoto < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :image
      t.boolean :accepted, default: false
      t.boolean :official, default: false
      t.references :karnevalist, index: true
    end
  end
end
