class AddQuestion4FromBookkeepings < ActiveRecord::Migration
  def change
    add_column :bookkeepings, :question_4, :Integer
  end
end
