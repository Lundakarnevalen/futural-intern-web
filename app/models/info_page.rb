# encoding: UTF-8
class InfoPage < ActiveRecord::Base
  belongs_to :sektion
  validates :sektion_id, presence: true
  validates :content, presence: true

end
