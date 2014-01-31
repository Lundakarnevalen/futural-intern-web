# encoding: utf-8
class Notification < ActiveRecord::Base
  validates :title, :presence => {:message => "Du måste skriva något i fältet Rubrik." }
  validates :message, :presence => {:message => "Du måste skriva något i fältet Meddelande." }
end
