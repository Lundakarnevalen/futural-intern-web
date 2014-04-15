# -*- encoding : utf-8 -*-
class InKarnevalistChangeUtcheckadToAvklaratSteg < ActiveRecord::Migration
  def change
    remove_column :karnevalister, :utcheckad
    add_column :karnevalister, :avklarat_steg, :integer
  end
end
