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

  validates :email, :presence => true

  before_save do
    if user.nil?
      # In memory only!
      @pass = SecureRandom.base64
      self.user = User.create :email => self.email, :password => @pass
    else
      user.email = self[:email]
      user.save
    end
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
end
