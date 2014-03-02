#encoding: utf-8
Kon.delete_all
{ 1 => 'Vill inte definiera mig',
  2 => 'Man',
  3 => 'Kvinna',
}.each{ |k, v| Kon.new do |i|
  i.id = k
  i.name = v
  i.save
end }

{ 1 => 3,
  2 => 2,
  3 => 1,
}.each do |podio, local|
  Kon.find(local).update_attributes :podio_id => podio
end

Nation.delete_all
{ 1  => 'Vet ej',
  2  => 'Blekingska',
  3  => 'Göteborgs',
  4  => 'Hallands',
  5  => 'Helsingkrona',
  6  => 'Kalmar',
  7  => 'Krischan',
  8  => 'Lunds',
  9  => 'Malmö',
  10 => 'Sydskånska',
  11 => 'Västgöta',
  12 => 'Wermlands',
  13 => 'Östgöta',
  14 => 'Smålands',
}.each{ |k, v| Nation.new do |i|
  i.id = k
  i.name = v
  i.save
end }

{ 1 => 2,
  2 => 3,
  3 => 4,
  4 => 5,
  5 => 6,
  6 => 7,
  7 => 8,
  8 => 9,
  9 => 14,
  10 => 10,
  11 => 11,
  12 => 12,
  13 => 13,
}.each do |podio, local|
  Nation.find(local).update_attributes :podio_id => podio
end

Storlek.delete_all
{ 1 => 'XS',
  2 => 'S',
  3 => 'M',
  4 => 'L',
  5 => 'XL',
  6 => 'XXL',
  7 => 'XXXL',
}.each{ |k, v| Storlek.new do |i|
  i.id = k
  i.name = v
  i.save
end }

{ 1 => 7,
  2 => 6,
  3 => 5,
  4 => 4,
  5 => 3,
  6 => 2,
  7 => 1,
}.each do |podio, local|
  Storlek.find(local).update_attributes :podio_id => podio
end

Korkort.delete_all
{ 1 => 'Inget',
  2 => 'B/BE',
  3 => 'B/BE + C/CE',
  4 => 'B/BE + D/DE',
  5 => 'B/BE + C/CE + D/DE',
}.each{ |k, v| Korkort.new do |i|
  i.id = k
  i.name = v
  i.save
end }

Korkort.all.each_with_index do |kk, i|
  kk.update_attributes :podio_id => (i + 1)
end

Intresse.delete_all
{
  1  => 'Mat',
  2  => 'Dryck',
  3  => 'Teknik (ljud, ljus, el)',
  4  => 'Layout/design',
  5  => 'IT',
  6  => 'Skriva',
  7  => 'Fota/filma/redigering',
  8  => 'Adminstration',
  9  => 'Försäljning',
  10 => 'Säkerhet',
  11 => 'Bygga/snickra',
  12 => 'Måla/dekoration',
  13 => 'Sy',
  14 => 'Smink',
  15 => 'Skådespela/sjunga/dansa/spela instrument',
  16 => 'Allt! Jag kan göra vad som helst, jag vill bara vara med.',
}.each{ |k, v| Intresse.new do |i|
  i.id = k
  i.name = v
  i.save
end }

Sektion.delete_all
{
  1   => 'Barnevalen',
  2   => 'Biljetteriet',
  3   => 'Blädderiet',
  4   => 'Cirkusen',
  5   => 'Dansen',
  6   => 'Ekonomi',
  7   => 'Kabarén',
  8   => 'Fabriken',
  9   => 'Klipperiet',
  10  => 'Kommunikation',
  11  => 'Krog Fine dine',
  12  => 'Krog l[a]unchingpad',
  13  => 'Krog Molnet',
  14  => 'Krog Nangilima',
  15  => 'Krog Undervatten',
  16  => 'Området',
  17  => 'Musiken',
  18  => 'Radion',
  19  => 'Revyn',
  20  => 'Shoppen',
  21  => 'Showen',
  22  => 'Snaxeriet',
  23  => 'Spexet',
  24  => 'Säkerhet',
  25  => 'Tombola',
  26  => 'Vieriet',
  27  => 'Filmen',
  28  => 'Nöjen',
  29  => 'Råd',

  100 => 'Festmästeriet - Bamba',
  101 => 'Festmästeriet - VIP',
  102 => 'Festmästeriet - Lager',
  199 => 'Festmästeriet - Centralt',

  202 => 'Smånöjena - Undergången',
  203 => 'Smånöjena - Sketcetera',
  204 => 'Smånöjena - FuturalFuneral',

  300 => 'Tåget - Vagn',
  399 => 'Tåget - Centralt',

  400 => 'Tältnöjen - Tält',
  499 => 'Tältnöjen - Centralt',

  500 => 'Jag vill bara vara med! Vilken sektion spelar ingen roll.',
  501 => 'Audition',

  999 => 'General'
}.each{ |k, v| Sektion.new do |i|
  i.id = k
  i.name = v
  i.save
end }

{
  1 => 1,   # Barnevalen
  2 => 2,   # Biljetteri
  3 => 3,   # Blädderi
  4 => 4,   # Cirkus
  5 => 5,   # Dansen
  6 => 6,   # Ekonomi
  7 => 8,   # Fabriken
  8 => 100, # Festmästeri
  9 => 27,  # Filmen
  10 => 7,  # Kabaré
  11 => 9,  # Klipperiet
  12 => 10, # Kommunikation
  13 => 11, # Krog 1
  14 => 12, # Krog 2
  15 => 13, # Krog 3
  16 => 14, # Krog 4
  17 => 16, # Område
  18 => 17, # Musik
  19 => 28, # Nöjen
  20 => 18, # Radio
  21 => 19, # Revy
  22 => 20, # Shoppen
  23 => 21, # Show
  24 => 22, # Snaxeriet
  25 => 23, # Spexet
  26 => 24, # Säkerhet
  27 => 25, # Tombola
  28 => 300,# Tåget
  29 => 400,# Tältnöje
  30 => 26, # Vieriet
  31 => 999,# General
  32 => 15, # Krog 5
  33 => 29, # Råd
}.each{ |podio, local|
  Sektion.find(local).update_attributes(:podio_id => podio)
}

Role.delete_all
{
  1 => 'admin',
  2 => 'utcheckare',
}.each{ |k, v| Role.new do |i|
  i.id = k
  i.name = v
  i.save
end }
