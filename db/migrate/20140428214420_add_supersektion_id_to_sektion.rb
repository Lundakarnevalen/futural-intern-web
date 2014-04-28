class AddSupersektionIdToSektion < ActiveRecord::Migration
  def change
    add_column :sektioner, :supersektion_id, :integer
  end
end
