class Karnevalist < ActiveRecord::Base
  has_and_belongs_to_many :intressen
  accepts_nested_attributes_for :intressen
  has_and_belongs_to_many :sektioner
  accepts_nested_attributes_for :sektioner
  belongs_to :kon
  belongs_to :nation
  belongs_to :storlek
  belongs_to :korkort
  belongs_to :user
  accepts_nested_attributes_for :user

  mount_uploader :foto, FotoUploader

  validates :email, :presence => true

  UTCHECKAD = 3

  before_save do
    if user.nil?
      # In memory only!
      @pass = SecureRandom.base64
      self.user = User.create :email => self.email, :password => @pass
    else
      user.email = self[:email]
      user.save
    end

    if utcheckad && utcheckad_at.nil?
      self.utcheckad_at = Time.now
    end
  end

  def self.search str
    words = str.split ' '
    # Search terms are chained together, one term after the other.
    q = self.all
    words.each do |w|
      if (i = Integer w rescue nil)
        # Search term is integer. Attempt direct match against id.
        direct_match = Karnevalist.find i rescue nil
        if direct_match
          # Break if direct match.
          return [direct_match]
        else
          # Else attempt match against personnummer.
          q = q.where('   id = :i
                       or personnummer like :is', :i => i, :is => "%#{i}%")
        end
      else
        # Search term is string. Attempt fuzzy match.
        q = q.where('   upper(fornamn) like upper(:w)
                     or upper(efternamn) like upper(:w)
                     or upper(email) like upper(:w)',
                     :w => "%#{w}%")
      end
    end
    return q
  end

  def personnummer= val
    self[:personnummer] = val.gsub /[^0-9]/, ''
  end

  def utcheckad= val
    self.avklarat_steg = UTCHECKAD if val
  end

  def utcheckad
    self.avklarat_steg == UTCHECKAD
  end

  def avklarat_steg= val
    self[:avklarat_steg] = val if self[:avklarat_steg].nil? or val > self[:avklarat_steg]
  end

  # In memory only
  def password
    @pass
  end

  def update_if_password_valid attr
    if true # user.valid_password? attr[:token]
      update_attributes! attr.except('token')
    else
      message = I18n.t 'devise.failure.invalid_token'
      fail StandardError, message
    end
  end

  def as_json(options={})
    super.merge({
      'intresse_ids' => self.intresse_ids,
      'sektion_ids' => self.sektion_ids,
    })
  end
end
