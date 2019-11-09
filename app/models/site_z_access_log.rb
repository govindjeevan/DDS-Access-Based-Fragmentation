class SiteZAccessLog < AccessLog
  self.table_name = "access_log"

  def self.read_write_access_volume(record)
    x=[1,2,3]
    avg_volume=[]
    total_avg_volume=0
    read_v = SiteZAccessLog.group('site_id').where(:rw => 0).count
    write_v = SiteZAccessLog.group('site_id').where(:rw => 1).count
    x.each do  |i|
      if read_v[i]+write_v[i]>= alpha
        avg_volume[i] =  (SiteZAccessLog.where(:site_id => i ).sum(:volume))/(read[i]+write[i])
        total_avg_volume +=avg_volume[i]
      end
    end
    total_avg_volume = total_avg_volume/x.length
    sites_eligible = []
    x.each do  |i|
      if avg_volume[i]>= total_avg_volume
        sites_eligible.push(i)
      end
    end

    site_allocated = -1
    if sites_eligible.length == 1
      site_allocated = sites_eligible[0]
    else
      prev_vol=0
      sites_eligible.each do |i|
        write_vol = SiteZAccessLog.where(:site_id => i, :rw => 1 ).sum(:volume)
        if (write_v[i]/write_vol)> prev_vol
          prev_vol = write_v[i]/write_vol
          site_allocated = i
        end
      end

    end

  end

end
