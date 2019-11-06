class SiteZRecord < ApplicationRecord
  self.abstract_class = true

  establish_connection :site_z
end
