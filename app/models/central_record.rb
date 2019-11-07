class CentralRecord < ApplicationRecord
  self.abstract_class = true

  establish_connection :central

  after_find do |record|
    CentralAccessLog.update_read_log(record)
  end
  # after_find do |record|
  #   # CentralAccessLog.update_read_log(record)
  #   puts "Read #{record.to_json}!"
  # end

  after_commit do |record|
    CentralAccessLog.update_write_log(record)
  end
end
