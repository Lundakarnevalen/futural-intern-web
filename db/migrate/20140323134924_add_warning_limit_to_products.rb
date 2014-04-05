class AddWarningLimitToProducts < ActiveRecord::Migration
  def change
    add_column :products, :warning_limit, :integer
  end
end
