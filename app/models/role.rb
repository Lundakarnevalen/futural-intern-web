# -*- encoding : utf-8 -*-
class Role < ActiveRecord::Base
  has_and_belongs_to_many :users

  IMPLEMENTED = [
    [ :admin, 
      'Har obegränsad access till alla internwebbens funktioner' ],
    [ :'access-admin',
      'Kan administrera sina egna och andras accesser' ],
    [ :info, 
      'Kan administrera nyheter, händelser och allmän info för sin sektion' ],
    [ :'global-info', 
      'Kan administrera nyheter, händelser och allmän info för alla sektioner' ],
    [ :sektionsadmin,
      'Kan se personuppgifter för medlemmarna i sin sektion' ],
    [ :sektionsadmin_lite,
      'Kan markera karnevalister som aktiva (sektionschefer, souschefer och kommunikationschefer)' ],
    [ :exporter,
      'Kan se personuppgifter för alla karnevalister' ],
    [ :checker,
      'Kan använda funktionen för att kontrollera om någon är karnevalist, ' +
      'kan däremot ej se några personuppgifter' ],
    [ :admin_fabriken,
      'Kan administrera fabrikens lagersystem' ],
    [ :admin_festmasteriet,
      'Kan administrera festmästeriets lagersystem' ],
    [ :bestallare_fabriken,
      'Kan lägga beställningar i fabrikens lagersystem' ],
    [ :bestallare_festmasteriet,
      'Kan lägga beställningar i festmästeriets lagersystem' ],
    [ :kassor_festmasteriet,
      'Kan administera vissa funktioner i festmästeriets lagersystem' ],
    [ :sektionsadmin_fabriken,
      'Kan se ordrar för hela sin sektion (ej endast sina egna ordrar).' ],
  ]

  def self.seed_roles
    IMPLEMENTED.each do |rr|
      name, desc = rr.first, rr.last
      r = Role.find_or_initialize_by_name name
      r.description = desc
      r.save
    end
  end
end
