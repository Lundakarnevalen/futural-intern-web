class Reservation < ActiveRecord::Base
  belongs_to :karnevalist
  validates :karnevalist, presence: true
  validate :reservation_time

  def total_time
    self.end_time - self.start_time
  end

  def reservation_time
    DateTime.now < self.start_time
  end

end
