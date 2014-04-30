# -*- encoding : utf-8 -*-

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :karnevalist
  has_and_belongs_to_many :roles

  before_save :ensure_authentication_token

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def is?(role)
    self.roles.any? {|r| r.name == role.to_s}
  end

  def remember_me
    true
  end

  def ability
    @ability ||= Ability.new(self)
  end
  delegate :can?, :cannot?, :to => :ability

  def sektioner
    if not self.karnevalist?
      return nil
    end

    sektion = [self.karnevalist.tilldelad_sektion]

    if sektion.include? 300 or sektion.include? 399
      sektion = [300, 399]
    end

    if sektion.include? 400 or sektion.include? 499
      sektion = [400, 499]
    end

    if sektion.include? 199 or sektion.include? 100 or sektion.include? 102
      sektion = [100, 102, 199]
    end

    return sektion
  end

  def karnevalist?
    return (not self.karnevalist.blank? and not self.karnevalist.tilldelad_sektion.blank?)
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
