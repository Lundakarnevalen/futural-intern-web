# -*- encoding : utf-8 -*-
class AddDetailsToBookkeepings < ActiveRecord::Migration
    def change
        change_table(:bookkeepings) { |t| t.timestamps }
    end
end