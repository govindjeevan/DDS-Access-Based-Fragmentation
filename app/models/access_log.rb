class AccessLog < Movie
  self.table_name = 'access_log'

  def self.update_read_log(record)
    unless record.class.to_s.include? 'AccessLog'
      AccessLog.create(site_id: record.id, rw: 0, fragment_id: 2, volume: 1)
    end
  end

  def self.update_write_log(record)
    unless record.class.to_s.include? 'AccessLog'
      AccessLog.create(site_id: record.site.id, rw: 1, fragment_id: 2, volume: 1)
    end
  end
end