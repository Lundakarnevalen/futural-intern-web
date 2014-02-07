class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name

      t.timestamps
    end

    create_table :user_roles do |t|
      t.belongs_to :role
      t.belongs_to :user
    end
  end
end
