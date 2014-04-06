FactoryGirl.define do

  factory :ability do
  end

  factory :intresse do
  end

  factory :role do
    name "testrole"
  end

  factory :karnevalist do
    personnummer "1111111116"
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
    ios_token nil
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

  factory :user_role do
    association :role, factory: :role
    user factory: :user
  end

  factory :user do
    sequence(:email) {|n| "test_#{n}@test.com"}
    password "testpassword"
    password_confirmation "testpassword"
    authentication_token nil
    association :karnevalist, factory: :karnevalist
    factory :user_with_role do
      after(:build) do |u|
        u.roles << FactoryGirl.create(:role)
      end
    end
  end

  factory :korkort do
    name "korkort"
  end

  factory :nation do
    name "nation"
  end

  factory :kon do
    name "kon"
  end

  factory :notification do
    title "a title"
    message "this is a message"
    recipient_id 0
  end

  factory :phone do
    sequence(:google_token) {|n| "token_#{n}"}
  end

  factory :sektion do
    name "kommunikation"
  end

  factory :storlek do
    name "storlek"
  end

  factory :sync do
  end

  factory :post do
    content "Lorem Ipsum"
    title "Title"
  end

  factory :cluster do
    lat ""
    lng ""
    quantity 1
  end

  factory :order do
    status "delivered"
    order_date Date.today
    delivery_date Date.tomorrow
    comment "No comment"
    association :karnevalist, factory: :karnevalist
    warehouse_code 0
  end

  factory :product_category do
    name "tools"
  end

  factory :product do
    product_type 1
    association :product_category, factory: :product_category
    name "hammare"
    unit "kg"
    ean "12345678910"
    supplier "bauhaus"
    info "information"
    stock_location "Lund"
    notes "en bra hammare"
    stock_balance_ordered 100
    stock_balance_not_ordered 200
    stock_balance_stand_by 50
    purchase_price 25.50
  end
end
