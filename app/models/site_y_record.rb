class SiteYRecord < ApplicationRecord
  self.abstract_class = true

  establish_connection :site_y
end
