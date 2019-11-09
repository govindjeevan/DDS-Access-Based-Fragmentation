class Movie < ApplicationRecord

  after_find do |record|
    AccessLog.update_read_log(record)
  end

  after_commit do |record|
    AccessLog.update_write_log(record)
  end

  def fragment_id
    release_date.year
  end

  def self.fetch_site_id(fragment_id)
    establish_connection(:central)
    QueryRouter.where(fragment_id: fragment_id).last.site_id
  end

  def self.fetch_movies(*args)
    result = []
    args.each do |x|
      if fetch_site_id(x) == 1
        establish_connection(:site_x)
      elsif fetch_site_id(x) == 2
        establish_connection(:site_y)
      elsif fetch_site_id(x) == 3
      establish_connection(:site_z)
      end
      result << Movie.where('YEAR( release_date ) = ?', x).pluck(:title)
    end
    result
  end
end