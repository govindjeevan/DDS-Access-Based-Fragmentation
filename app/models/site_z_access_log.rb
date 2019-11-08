class SiteZAccessLog < AccessLog
  self.table_name = "access_log"

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
