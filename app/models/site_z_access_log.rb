class SiteZAccessLog < SiteZRecord
  self.table_name = "access_log"

  def self.update_read_log(record)
    if record.class != SiteZAccessLog
      SiteZAccessLog.create(site_id: record.id, rw: 0, fragment_id: 2, volume: 1)
    end
  end

  def self.update_write_log(record)
    if record.class != SiteZAccessLog
      SiteZAccessLog.create(site_id: record.id, rw: 1, fragment_id: 2, volume: 1)
    end
  end

  def self.read_write_access_volume(record)
    x=[1,2,3]
    read_v = SiteZAccessLog.group('site_id').where(:rw => 0).count
    write_v = SiteZAccessLog.group('site_id').where(:rw => 1).count
    x.each do  |i|
      if read_v[i]+write_v[i]>= alpha
        SiteZAccessLog.where(:site_id => i ).sum(:volume)

      end
    end

  end

end
