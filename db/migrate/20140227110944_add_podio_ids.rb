class AddPodioIds < ActiveRecord::Migration
  def change
    add_column :kon, :podio_id, :integer
    add_column :korkort, :podio_id, :integer
    add_column :nationer, :podio_id, :integer
    add_column :sektioner, :podio_id, :integer
    add_column :storlekar, :podio_id, :integer
    
    add_index :kon, [:podio_id], :name => 'index_kon_on_podio_id'
    add_index :korkort, [:podio_id], :name => 'index_korkort_on_podio_id'
    add_index :nationer, [:podio_id], :name => 'index_nationer_on_podio_id'
    add_index :sektioner, [:podio_id], :name => 'index_sektioner_on_podio_id'
    add_index :storlekar, [:podio_id], :name => 'index_storlekar_on_podio_id'
    add_index :karnevalister, [:podio_id], :name => 'index_karnevalister_on_podio_id'
  end
end
