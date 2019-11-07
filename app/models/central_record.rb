class CentralRecord < ApplicationRecord
  self.abstract_class = true

  establish_connection :central

  after_find do |record|
    puts "Read #{record.to_json}!"
  end

  after_commit do |record|
    puts "Write #{record.to_json}!"
  end
end
