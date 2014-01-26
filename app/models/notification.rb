class Notification < ActiveRecord::Base
  validates :text, :presence => {:message => "Du måste skriva något i fältet." }
end
