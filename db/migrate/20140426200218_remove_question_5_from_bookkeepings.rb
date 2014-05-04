class RemoveQuestion5FromBookkeepings < ActiveRecord::Migration
  def change
    remove_column :bookkeepings, :question_5, :Integer
  end
end
