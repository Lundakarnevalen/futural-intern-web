class Reservation < ActiveRecord::Base
  belongs_to :karnevalist
  validates :karnevalist, presence: true
  validate :reservation_time

  scope :between, lambda { |start_time, end_time|
    where("? < start_time < ?",
      Reservation.format_date(start_time),
      Reservation.format_date(end_time)
    )
  }

  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
  end

  def reservation_time
    errors.add(:starttiden, "har redan inträffat") if DateTime.now > self.start_time
  end

  def as_json(options = {})
    {
      id: self.id,
      title: "#{Sektion.find(self.karnevalist.tilldelad_sektion).name}",
      description: self.message || "",
      start: self.start_time,
      end: self.end_time,
      allDay: false,
      recurring: false,
      url: Rails.application.routes.url_helpers.fabriken_reservation_path(self.id)
    }
  end

end
