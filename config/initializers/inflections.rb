# Add Swedish inflections
ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'karnevalist', 'karnevalister'
  inflect.irregular 'intresse', 'intressen'
  inflect.irregular 'sektion', 'sektioner'
  inflect.irregular 'kon', 'kon'
  inflect.irregular 'storlek', 'storlekar'
  inflect.irregular 'nation', 'nationer'
  inflect.irregular 'korkort', 'korkort'
end
