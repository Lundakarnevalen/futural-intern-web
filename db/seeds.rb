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

Storlek.delete_all
{
  1 => 'XS',
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
  27  => 'Jag vill bara vara med! Vilken sektion spelar ingen roll.',

  100 => 'Festmästeriet - Bamba',
  101 => 'Festmästeriet - VIP',
  102 => 'Festmästeriet - Lager',

  202 => 'Smånöjena - Undergången',
  203 => 'Smånöjena - Sketcetera',
  204 => 'Smånöjena - FuturalFuneral',

  300 => 'Tåget - Vagn',
  399 => 'Tåget - Centralt',

  400 => 'Tältnöjen - Tält',
  499 => 'Tältnöjen - Centralt',
}.each{ |k, v| Sektion.new do |i|
  i.id = k
  i.name = v
  i.save
end }

# Add J. Random Hacker
Karnevalist.create({
  :personnummer => '9110251817',
  :fornamn => 'Johan',
  :efternamn => 'Förberg',
  :kon_id => Kon.where(:name => 'Man').first.id(),
  :gatuadress => 'Möllevångsvägen 14B',
  :postnr => '222 40',
  :postort => 'Lund',
  :email => 'johan@forberg.se',
  :telnr => '0709-690 424',
  :nation_id => Nation.where(:name => 'Blekingska').first.id(),
  :matpref => 'Äter det mesta',
  :storlek_id => 0,
  :terminer => 7,
  :engagerad_kar => 'Harvat heltid på TLTH',
  :engagerad_nation => 'Blandat drinkar på Blekingska',
  :engagerad_studentikos => 'Spelat falskt i Bleckhornen',
  :engagerad_etc => 'Spelat rent i flottans ungdomsmusikkår',
  :jobbat_heltid => true,
  :jobbat_styrelse => true,
  :jobbat_forman => true,
  :jobbat_aktiv => true,
  :karnevalist_2010 => false,
  :intressen => Intresse.where(:name => 'Allt! Jag kan göra vad som helst, jag vill bara vara med.'),
  :sektioner => Sektion.where(:name => 'Jag vill bara vara med! Vilken sektion spelar ingen roll.'),
  :medlem_af => false,
  :medlem_kar => true,
  :medlem_nation => false,
  :karneveljsbiljett => false,
})
