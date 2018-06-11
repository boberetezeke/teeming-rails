class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def validate_time(time_sym)
    time_str_sym = "#{time_sym}_str"
    time_str = self.send(time_str_sym)
    time_str = time_str.strip if time_str
    return true if time_str.blank?

    m = /^(\d+):(\d+)([APap][mM]?)?$/.match(time_str)
    if m
      hour, minute, am_pm = m.captures

      hour = hour.to_i
      minute = minute.to_i

      if (am_pm &&  (hour < 1 || hour > 12)) ||
         (!am_pm && (hour < 0 || hour >= 24))
        errors.add(time_str_sym, "invalid hour '#{hour}'")
        return false
      end

      if minute < 0 || minute >= 60
        errors.add(time_str_sym, "invalid minute '#{minute}'")
        return false
      end

      hour += 12 if am_pm && am_pm =~ /^[Pp]/ && hour != 12

      time_value = Time.zone.local(2017, 1, 1, hour, minute)
      if block_given?
        yield time_value
      else
        self.send("#{time_sym}=", time_value)
      end
      return true
    else
      errors.add(time_str_sym, "invalid time")
      false
    end
  end

  def validate_date(date_sym)
    date_str_sym = "#{date_sym}_str"
    date_str = self.send(date_str_sym)
    return true if date_str.blank?

    m = /(\d+)\/(\d+)\/(\d+)/.match(date_str)
    if m
      month, day, year = m.captures.map(&:to_i)
      if month < 1 || month > 12
        errors.add(date_sym_str, "invalid month '#{month}'")
        return false
      end

      if day < 0 || day > 31
        errors.add(date_sym_str, "invalid day '#{day}'")
        return false
      end

      if year < 2017 || year > 2100
        errors.add(date_sym_str, "invalid year '#{year}'")
        return false
      end

      date_value = Date.new(year, month, day)
      if block_given?
        yield date_value
      else
        self.send("#{date_sym}=", date_value)
      end
      return true
    else
      errors.add(date_sym_str, "invalid date")
      false
    end
  end
end
