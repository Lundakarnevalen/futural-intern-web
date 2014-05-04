class CreateBookkeepings < ActiveRecord::Migration
  def change
    create_table :bookkeepings do |t|
      t.integer :karnevalist_id
      t.string :question_1
      t.string :question_2
      t.string :question_3
      t.string :question_4
      t.integer :question_5
    end
  end
end
