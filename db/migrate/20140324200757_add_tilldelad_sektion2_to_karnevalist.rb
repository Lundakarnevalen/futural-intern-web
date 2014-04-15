# -*- encoding : utf-8 -*-
class AddTilldeladSektion2ToKarnevalist < ActiveRecord::Migration
  def change
    add_column :karnevalister, :tilldelad_sektion2, :integer
  end
end
