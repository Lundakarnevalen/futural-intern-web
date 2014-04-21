class AddEnglishAndContaktPageToSektion < ActiveRecord::Migration
  def change
    add_column :sektioner, :english_page, :string
    add_column :sektioner, :contact_page, :string
  end
end
