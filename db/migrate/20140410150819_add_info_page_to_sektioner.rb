class AddInfoPageToSektioner < ActiveRecord::Migration
  def change
    add_column :sektioner, :info_page, :string
  end
end
