class Movie < ApplicationRecord

  def fragment_id
    release_date&.year
  end

  scope :find_by_year, ->(year) { where('extract( year from release_date ) = ?', year) }
  scope :released_between, ->(start_date, end_date) { where('release_date >= ? AND release_date <= ?', start_date, end_date).order(:release_date) }

  def self.movies_by_site(site)
    ApplicationRecord.establish_connection_to_site(site)
    Movie.all.pluck(:title, :release_date).to_a
  end

  def self.fetch_fragment_by_year(year, current_site)
    # searching record in local site
    ApplicationRecord.establish_connection_to_site(current_site)
    result = Movie.find_by_year(year)
    if result.present?
      AccessLog.create_read_log(year, result.count, current_site)
      return result
    else
      # if record not found locally
      # finding the remote site with the fragment
      fragment_site_id = QueryRouter.find_site_of_fragment(year)
      if fragment_site_id
        # connecting to the remote database and querying it
        ApplicationRecord.establish_connection_to_site(fragment_site_id)
        result = Movie.find_by_year(year)
        if result.present?
          AccessLog.create_read_log(year, result.count, current_site)
          QueryRouter.optimize_fragment_site(year, current_site)
          return result
        end
      end
    end
    nil
  end

  def self.fetch_movies(start_time, end_time, current_site)
    ApplicationRecord.establish_connection_to_site(current_site)
    result = Movie.released_between(start_time, end_time)
    if result.present?
      AccessLog.create_read_log(start_time.year, result.count, current_site)
      return result
    else
      # if record not found locally
      # finding the remote site with the fragment
      fragment_site_id = QueryRouter.find_site_of_fragment(start_time.year)
      if fragment_site_id
        # connecting to the remote database and querying it
        ApplicationRecord.establish_connection_to_site(fragment_site_id)
        result = Movie.released_between(start_time, end_time)
        if result.present?
          AccessLog.create_read_log(start_time.year, result.count, current_site)
          QueryRouter.optimize_fragment_site(start_time.year, current_site)
          return result
        end
      end
    end
    nil
  end

  def self.fetch_fragment_by_time(start_time, end_time, current_site)
    # Same fragment
    if start_time.year == end_time.year
      movies = fetch_movies(start_time, end_time, current_site)
    else
      years = (start_time.year + 1..end_time.year - 1).to_a
      movies = fetch_movies(start_time, start_time.end_of_year, current_site) || []
      years.each do |yr_i|
        yr = DateTime.new(yr_i)
        movies += fetch_movies(yr.beginning_of_year, yr.end_of_year, current_site) || []
      end
      movies += fetch_movies(end_time.beginning_of_year, end_time, current_site) || []
    end
    movies
  end
end