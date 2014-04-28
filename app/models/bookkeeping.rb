# -*- encoding : utf-8 -*-
class Bookkeeping < ActiveRecord::Base
  belongs_to :karnevalist

  def self.find_dates
    dates = Array.new
    bookkeepings = Bookkeeping.all
    if !bookkeepings.empty?
      dates.push(bookkeepings.first.created_at)
      bookkeepings.each_with_index do |b, i|
        if (bookkeepings[i+1] != nil)
          timestamp = b.created_at.day - bookkeepings[i+1].created_at.day
          if  (timestamp != 0)
            dates.push(bookkeepings[i+1].created_at)
          end
        end
      end
    end
    dates = remove_duplicates(dates)
    return dates
  end

  def self.get_all_dates
    bookkeepings = Bookkeeping.all
    dates_array = Array.new
    bookkeepings.each do |b|
      date = b.created_at
      day_month = date.day.to_s + "/" + date.month.to_s
      dates_array.push(day_month)
    end
    dates_array = remove_duplicates_string(dates_array)
    dates_array = dates_array.sort
    return dates_array
  end

  def self.remove_duplicates dates
      dates.each do |d|
        count = 0
        dates.each do |d2|
          if (d.day == d2.day) and (d.month == d2.month)
            count += 1
          end
        end
        if count > 1
          dates.delete(d)
        end
      end
    dates = dates.sort
    dates = dates.reverse
    return dates
  end

  def self.remove_duplicates_string dates
    dates.each do |d|
      count = 0
      dates.each do |d2|
        if (d == d2)
          count += 1
        end
      end
      if count > 1
        dates.delete(d)
        dates.push(d)
      end
    end
    return dates
  end

  def is_in_date date
    timestamp = self.created_at.day - date.day
    if timestamp == 0
      return true
    else
      return false
    end
  end
end