# -*- encoding : utf-8 -*-
class Attendance < ActiveRecord::Base
  belongs_to :karnevalist
  belongs_to :event

  validates :karnevalist, :event, :presence => true
  validate do
    return unless event.present?
    if event.date.past?
      errors.add :event, 'Den händelsen har redan varit!'
    end

    unless event.attendable?
      errors.add :event, 'Händelsen tar inte emot anmälningar.'
    end
  end
  
  # Create new attendance or update existing.
  def self.create_or_update attr = {}
    xa = Attendance.new attr
    a = Attendance.where(:event => xa.event, :karnevalist => xa.karnevalist)
                  .first || Attendance.new
    a.update_attributes attr
    return a
  end

  def self.existing_or_new attr = {}
    Attendance.where(:event => attr[:event], :karnevalist => attr[:karnevalist])
              .first ||
      Attendance.new
  end

  ATTRIBUTES_FOR_EXPORT = 
    [ :comment, :created_at ]
  ATTRIBUTES_FROM_KARNEVALIST_FOR_EXPORT =
    [ :fornamn, :efternamn, :matpref ]

  def self.attributes_for_header
    (ATTRIBUTES_FROM_KARNEVALIST_FOR_EXPORT + ATTRIBUTES_FOR_EXPORT)
        .map(&:to_s).map(&:capitalize)
  end

  def attributes_for_export
    ATTRIBUTES_FROM_KARNEVALIST_FOR_EXPORT.map{ |attr|
       self.karnevalist.send(attr).to_s
    } + ATTRIBUTES_FOR_EXPORT.map{ |attr|
       self.send(attr).to_s
    }
  end
end
