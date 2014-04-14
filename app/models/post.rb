# encoding: UTF-8

class Post < ActiveRecord::Base

  belongs_to :karnevalist
  belongs_to :sektion

  validates :content, :presence => {:message => "Du måste skriva något!" }
  validates :title, :presence => {:message => "Du måste ange en Rubrik" }

  default_scope -> { order('created_at DESC') }

  scope :for_sektioner, -> sektioner {
    self.where 'sektion_id in (?) or sektion_id is null', sektioner.map(&:id)
  }

end
