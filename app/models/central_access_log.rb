class CentralAccessLog < CentralRecord
  self.table_name = 'central_access_log'

  def self.update_read_log(record)
    if record.class != CentralAccessLog
      CentralAccessLog.create(site_id: 0, rw: 0, fragment_id: record.id, volume: 1)
    end
  end

  def self.update_write_log(record)
    if record.class != CentralAccessLog
      CentralAccessLog.create(site_id: 0, rw: 1, fragment_id: record.id, volume: 1)
    end
  end

end
