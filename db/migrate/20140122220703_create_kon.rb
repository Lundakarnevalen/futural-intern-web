class CreateKon < ActiveRecord::Migration
  def change
    create_table :kon do |t|
      t.string :name, :null => false
    end
  end
end
