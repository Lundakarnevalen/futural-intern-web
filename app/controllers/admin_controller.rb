class AdminController < ApplicationController
  before_filter :authenticate_user!

  def dump
    con = ActiveRecord::Base.connection
    data = con.tables.map{ |table|
      result = con.exec("select * from `#{table}`")
      fields = result.fields
      [table, entries.map{ |entry|
        fields.zip(entry)
      }.inject({}) { |acc, pair|
        acc[pair.first] = pair.last
      }
    }.inject({}) {|acc, pair|
      acc[pair.first] = pair.last
    }
    render :json => data
  end
end
    
