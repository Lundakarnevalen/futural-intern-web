class CreateKarnevalister < ActiveRecord::Migration
  def change
    create_table :karnevalister do |t|
      t.string  :personnummer
      t.integer :kon_id
      t.string  :fornamn
      t.string  :efternamn
      t.string  :gatuadress
      t.string  :postnr
      t.string  :postort
      t.string  :email
      t.string  :telnr
      t.integer :nation_id
      t.string  :matpref
      t.integer :storlek_id
      t.integer :terminer
      t.integer :korkort_id
      t.string  :engagerad_kar
      t.string  :engagerad_nation
      t.string  :engagerad_studentikos
      t.string  :engagerad_etc
      t.boolean :jobbat_heltid
      t.boolean :jobbat_styrelse
      t.boolean :jobbat_forman
      t.boolean :jobbat_aktiv
      t.boolean :karnevalist_2010
      t.string  :google_token
      t.boolean :vill_ansvara
      # Foreign key 'intressen'
      t.integer :snalla_intresse
      # Foreign key 'sektioner'
      t.integer :snalla_sektion
      t.text    :ovrigt
      t.string  :foto
      t.boolean :medlem_af
      t.boolean :medlem_kar
      t.boolean :medlem_nation
      t.boolean :karneveljsbiljett
      t.boolean :utcheckad
      t.timestamps
    end
  end
end
