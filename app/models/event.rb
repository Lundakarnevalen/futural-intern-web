class Event < ActiveRecord::Base
  belongs_to :creator, :class_name => :User
  belongs_to :sektion

  validates :title, :presence => true
  validates :description, :presence => true

  scope :upcoming, -> { 
    self.where 'date >= ?', Date.today
  }

  scope :for_sektion, -> sektion {
    self.where 'sektion_id = ? or sektion_id is null', sektion.id
  }

  def creator_karnevalist
    if self.creator.present? && self.creator.karnevalist.present?
      self.creator.karnevalist
    end
  end
end
