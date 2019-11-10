class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.establish_connection_to_site(site)
      if site == 1
        establish_connection(:site_x)
      elsif site == 2
        establish_connection(:site_y)
      elsif site == 3
        establish_connection(:site_z)
      end
  end

end
