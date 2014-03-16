FactoryGirl.define do

	factory :ability do
	end

	factory :intresse do
	end

  factory :karnevalist do
    personnummer "8008088080"
    sequence(:kon_id) {|n| n}
    fornamn "MyString"
    efternamn "MyString"
    gatuadress "MyString"
    postnr "MyString"
    postort "MyString"
    sequence(:email) {|n| "test#{n}@mail.com"}
    telnr "MyString"
    matpref "MyString"
    terminer 1
    engagerad_kar "MyString"
    engagerad_nation "MyString"
    engagerad_studentikos "MyString"
    engagerad_etc "MyString"
    jobbat_heltid false
    jobbat_styrelse false
    jobbat_forman false
    jobbat_aktiv false
    karnevalist_2010 false
    google_token "MyText"
    vill_ansvara false
    snalla_intresse 1
    snalla_sektion 1
    ovrigt "MyText"
    medlem_af false
    medlem_kar false
    medlem_nation false
    karneveljsbiljett false
    utcheckad_at nil 
    avklarat_steg 1
    foto "MyString"
    tilldelad_sektion 1
    tilldelad_klar false
    pusseldag_keep false
    medlem_kollad false
  end

  factory :korkort do
  end

  factory :nation do
  end

  factory :notification do
  end

  factory :phone do
  end

  factory :role do
  end

  factory :sektion do
  end

  factory :storlek do
  end

  factory :sync do
  end
  
  factory :user do
  end
   
    

end
