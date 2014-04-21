class ChangeStringTypeToText < ActiveRecord::Migration
  def up
   change_column :posts,     :content,      :text, :limit => nil
   change_column :sektioner, :info_page,    :text, :limit => nil
   change_column :sektioner, :english_page, :text, :limit => nil
   change_column :sektioner, :contact_page, :text, :limit => nil
  end

  def down
   change_column :posts,     :content,      :string
   change_column :sektioner, :info_page,    :string
   change_column :sektioner, :english_page, :string
   change_column :sektioner, :contact_page, :string
  end
end
