class Movie < ApplicationRecord

  def fragment_id
    release_date.year
  end

  scope :find_by_year, ->(year) { where("extract( year from release_date ) = ?", year) }

  def self.fetch_fragment(year)
    # searching record in local site
    ApplicationRecord.establish_connection_to_site(@site)
    result = Movie.find_by_year(year)
    if result.present?
      AccessLog.create_read_log(year, result.count)
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
          AccessLog.create_read_log(year, result.count)
          return result
        end
      end
    end
    return nil
  end
end