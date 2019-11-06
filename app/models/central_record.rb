class CentralRecord < ApplicationRecord
  self.abstract_class = true

  establish_connection :central
end
