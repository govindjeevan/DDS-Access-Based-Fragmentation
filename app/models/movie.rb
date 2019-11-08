class Movie < ApplicationRecord
  after_find do |record|
    AccessLog.update_read_log(record)
  end

  after_commit do |record|
    AccessLog.update_write_log(record)
  end

  def self.find(*args)
    if args.last == 1
      establish_connection(:site_x)
    elsif args.last == 2
      establish_connection(:site_y)
    elsif args.last == 3
      establish_connection(:site_z)
    end
    args.pop
    super
  end
end