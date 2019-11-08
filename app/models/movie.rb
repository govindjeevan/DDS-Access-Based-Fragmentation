class Movie < ApplicationRecord
  def self.find(*args)
    if args[1] && args[1] == 1
      establish_connection(:site_x)
    elsif args[1] && args[1] == 2
      establish_connection(:site_y)
    elsif args[1] && args[1] == 3
      establish_connection(:site_z)
    end
    super
  end
end