class SiteXRecord < ApplicationRecord
  self.abstract_class = true

  establish_connection :site_x
end
