# -*- encoding: utf-8 -*-

class Event < ActiveRecord::Base
  belongs_to :creator, :class_name => :User
  belongs_to :sektion
 
  has_many :attendances, :dependent => :destroy

  validates :title, :presence => true
  validates :description, :presence => true
  validates :date, :presence => true

  validate do
    if end_date.present? && end_date <= date
      errors.add :end_date, 'Kan inte börja efter att det slutar'
    end

    if date.present? && date.past?
      errors.add :date, 'Kan inte börja bakåt i tiden'
    end
  end

  scope :upcoming, -> { 
    self.where('date >= ? or end_date >= ?', Date.today, Date.today)
        .order('date asc')
  }

  scope :for_sektioner, -> sektioner {
    self.where 'sektion_id in (?) or sektion_id is null', sektioner.map(&:id)
  }

  scope :with_tickets, -> {
    self.where :tickets => true
  }

  def creator_karnevalist
    if self.creator.present? && self.creator.karnevalist.present?
      self.creator.karnevalist
    end
  end

  def attendable?
    !! self.attendable
  end

  def attending? karnevalist
    attendances.where(:karnevalist => karnevalist).any?
  end

  def tickets? 
    !! self.tickets
  end

  def to_s
    "#{title}, #{date}"
  end
end
