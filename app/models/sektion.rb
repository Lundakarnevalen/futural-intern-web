# -*- encoding : utf-8 -*-
class Sektion < ActiveRecord::Base
  has_and_belongs_to_many :karnevalister
  has_many :posts
  has_many :orders
  has_one :blockorder
  has_many :images
  belongs_to :supersektion, :class_name => Sektion
  has_many :subsektioner, :class_name => Sektion,
           :foreign_key => :supersektion_id

  validate do # no recursive subsektioner!
    if (subsektioner.any? && supersektion.present?) ||
       (supersektion.present? && supersektion.supersektion.present?)
      errors.add :supersektion, 'Subsektion kan inte ha egna subsektioner'
    end
  end

  scope :with_subsektioner, -> (ids) do
    unless ids.present? || ids.any?
      return []
    end
    ids = [ids] unless ids.respond_to? :each
    return Sektion.where 'id in (?) or supersektion_id in (?)', ids, ids
  end

  def members
    Karnevalist.where('tilldelad_sektion = ? or tilldelad_sektion2 = ?', self.id, self.id).order('efternamn, fornamn asc')
  end

  def to_s
    self.name
  end
end
