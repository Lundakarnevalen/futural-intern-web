#encoding: utf-8
Kon.delete_all
{ 0 => 'Oklart',
  1 => 'Man',
  2 => 'Kvinna',
}.each{ |k, v| Kon.create :id => k, :name => v }

Nation.delete_all
{ 0  => 'Oklart',
  1  => 'Blekingska',
  2  => 'Göteborgs',
  3  => 'Hallands',
  4  => 'Helsingkrona',
  5  => 'Kalmar',
  6  => 'Krischan',
  7  => 'Lunds',
  8  => 'Malmö',
  9  => 'Sydskånska',
  10 => 'Västgöta',
  11 => 'Wermlands',
  12 => 'Östgöta',
  13 => 'Smålands',
}.each{ |k, v| Nation.create :id => k, :name => v }

Storlek.delete_all
{ 0 => 'Oklar',
  1 => 'XS',
  2 => 'S',
  3 => 'M',
  4 => 'L',
  5 => 'XL',
  6 => 'XXL',
  7 => 'XXXL',
}.each{ |k, v| Storlek.create :id => k, :name => v }

Korkort.delete_all
{ 0 => 'Ingen',
  1 => 'B/BE',
  2 => 'B/BE + C/CE',
  3 => 'B/BE + D/DE',
  4 => 'B/BE + C/CE + D/DE',
}.each{ |k, v| Korkort.create :id => k, :name => v }

Intresse.delete_all
{ 0  => 'Billig',
  1  => 'Mat',
  2  => 'Dryck',
  3  => 'Teknik',
  4  => 'Layout',
  5  => 'IT',
  6  => 'Skriva',
  7  => 'Fota & filma',
  8  => 'Adminstration',
  9  => 'Försäljning',
  10 => 'Säkerhet',
  11 => 'Bygga',
  12 => 'Dekorera',
  13 => 'Sy',
  14 => 'Smink',
  15 => 'Spexeri',
}.each{ |k, v| Intresse.create :id => k, :name => v }

Sektion.delete_all
{ 0   => 'Billig',
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

  100 => 'Festmästeriet - Bamba',
  101 => 'Festmästeriet - VIP',
  102 => 'Festmästeriet - Lager',

  200 => 'Smånöjen - Vad som',
  202 => 'Smånöjen - Undergången',
  203 => 'Smånöjen - Sketcetera',
  204 => 'Smånöjen - FuturalFuneral',

  300 => 'Tåget - Vagn',
  399 => 'Tåget - Centralt',

  400 => 'Tältnöjen - Tält',
  499 => 'Tältnöjen - Centralt',
}.each{ |k, v| Sektion.create :id => k, :name => v }

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
  :intressen => Intresse.where(:name => 'Billig'),
  :sektioner => Sektion.where(:name => 'Billig'),
  :medlem_af => false,
  :medlem_kar => true,
  :medlem_nation => false,
  :karneveljsbiljett => false,
  :utcheckad => false,
})

# Add J. Random Hackress
Karnevalist.create({
  :personnummer => '9101245240',
  :fornamn => 'Filippa',
  :efternamn => 'de Laval',
  :kon_id => Kon.where(:name => 'Kvinna').first.id(),
  :utcheckad => true,
})
