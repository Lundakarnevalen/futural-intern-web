class RemoveQuestion4FromBookkeepings < ActiveRecord::Migration
  def change
    remove_column :bookkeepings, :question_4, :String
  end
end
