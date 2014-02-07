class Phone < ActiveRecord::Base
  validates_uniqueness_of :google_token
end
