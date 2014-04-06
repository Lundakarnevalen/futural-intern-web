# encoding: utf-8
class Notification < ActiveRecord::Base
  validates :title, :presence => {:message => "Du måste skriva något i fältet Rubrik." }
  validates :message, :presence => {:message => "Du måste skriva något i fältet Meddelande." }

  def as_json(options = {})
    options[:except] ||= [:created_at, :updated_at]
    json = super(options)
    json[:created_at] = self.created_at.strftime("%Y-%m-%d %H:%M")
    json
  end
end
