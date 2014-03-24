# encoding: utf-8

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
  belongs_to :sektion, :foreign_key => :tilldelad_sektion
  belongs_to :sektion2, :foreign_key => :tilldelad_sektion2, 
                        :class_name => Sektion
  accepts_nested_attributes_for :user

  mount_uploader :foto, FotoUploader

  before_validation :downcase_email

  validates :email, :presence => true, :uniqueness => true

  validate do # Personnummer
    if self.personnummer.blank?
      nil
    elsif ! Karnevalist.personnummer?(self.personnummer)
      self.errors.add :personnummer, 'Ogiltigt personnummer'

  validate do # Sektioner not equal
    if self.sektion.present? && self.sektion2.present? &&
       self.sektion == self.sektion2
      self.errors.add :sektion2, 'Välj två olika sektioner'
    end
  end

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

    if self.avklarat_steg.nil?
      self.avklarat_steg = 0
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
    self[:personnummer] = val.blank?? nil : Karnevalist.to_personnummer(val)
  end

  # About sektioner: naming is severely fucked up. To clarify:
  # `tilldelad_sektion` and `tilldelad_sektion2` are the IDs of the assigned
  # sektions. The associations are named `sektion` and `sektion2`. Most clients
  # should REALLY use `tilldelade_sektioner` which gives the ASSOCIATIONS of as
  # many sektions as are assigned, in order of precedence. `sektioner` is the
  # sektions that were originally requested but they are only kept for legacy
  # purposes. Clear?

  def tilldelade_sektioner= sekts
    if sekts.blank?
      self.sektion = nil
      self.sektion2 = nil
    elsif sekts.length > 2
      fail ValueError, 'Number of sektioner must be 0, 1, or 2.'
    elsif sekts.length == 2
      self.sektion = sekts[0]
      self.sektion2 = sekts[1]
    else # == 1
      self.sektion = sekts[0]
      self.sektion2 = nil
    end
  end

  def tilldelade_sektioner
    [self.sektion, self.sektion2].select &:present?
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

  def checkin
    self[:avklarat_steg] = 2
    save
  end

  # In memory only
  def password
    @pass
  end

  def as_json(options={})
    super.merge({
      'intresse_ids' => self.intresse_ids,
      'sektion_ids' => self.sektion_ids,
    })
  end

  # Base64 Upload as explained by Radek Paviensky
  # http://stackoverflow.com/a/14904045/1227116
  def image_data=(data)
    io = CarrierStringIO.new(Base64.decode64(data))

    self.foto = io
  end

  def image_data
    ""
  end

  def foto_filtyp
    URI.parse(URI.encode(self.foto.to_s)).path[%r{[^\.]+\z}]
  end

  def downcase_email
    self.email = self.email.downcase if self.email.present?
  end
  
  ATTRIBUTES_FOR_EXPORT =
    [:personnummer, :efternamn, :fornamn, :kon, :telnr, :email, :gatuadress,
     :postnr, :postort, :nation, :matpref, :storlek, :korkort]

  ATTRIBUTES_FOR_EXPORT_ALL = [:id, :sektion, :foto_filtyp] + ATTRIBUTES_FOR_EXPORT

  def self.attributes_for_export_header
    ATTRIBUTES_FOR_EXPORT.map(&:to_s).map(&:capitalize)
  end

  def self.attributes_for_export_all_header
    ATTRIBUTES_FOR_EXPORT_ALL.map(&:to_s).map(&:capitalize)
  end

  def attributes_for_export
    ATTRIBUTES_FOR_EXPORT.map do |attr|
      self.send(attr).to_s
    end
  end

  def attributes_for_export_all
    ATTRIBUTES_FOR_EXPORT_ALL.map do |attr|
      self.send(attr).to_s
    end
  end

  def to_s
    if self.fornamn.present? || self.efternamn.present?
      "#{self.fornamn} #{self.efternamn} (#{self.personnummer})"
    else 
      "NAMNLÖS KARNEVALIST #{self.hash}"
    end
  end

  def self.personnummer? pn
    return false unless pn.length == 10
    # Validate year
    begin # BEWARE: catches invocation errors as well
      return false unless pn[0..1].to_i.between? 0, 99
      # Validate month, day
      Date.parse pn[0..5] # Fail if invalid
      # Validate last four unless 'international' number
      unless ['t', 'p'].include? pn[6].downcase
        # Code's unreadable, deal with it.
        val = pn[0..8].chars.zip('212121212'.chars).inject 0 do |acc, cs|
          acc + (cs[0].to_i * cs[1].to_i).to_s.chars.map(&:to_i).sum
        end
        chk = (10 - (val % 10)) % 10
        return false unless chk == pn[-1].to_i
      end
    rescue ArgumentError
      return false
    end
    return true
  end

  def self.to_personnummer pn
    pn.gsub! /-/, ''
    if pn.length == 12
      # Chop off century
      pn = pn[2..-1]
    end
    return pn.upcase
  end
end

class CarrierStringIO < StringIO
  def original_filename
    # the real name does not matter
    "photo.jpeg"
  end

  def content_type
    # this should reflect real content type, but for this example it's ok
    "image/jpeg"
  end
end
