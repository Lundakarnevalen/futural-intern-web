# -*- encoding : utf-8 -*-
class AddPodioSubIdToSektioner < ActiveRecord::Migration
  def change
    add_column :sektioner, :podio_sub_id, :integer
  end
end
