class AccessLog < Movie
  self.table_name = 'access_log'

  def self.create_read_log(fragment_id, volume, current_site)
      AccessLog.create(site_id: current_site, rw: 0, fragment_id: fragment_id, volume: volume)
  end

  def self.create_write_log(fragment_id, volume, current_site)
      AccessLog.create(site_id: current_site, rw: 1, fragment_id: fragment_id, volume: volume)
  end


  def self.fragment_accesses(fragement_id, beta)
    logs = []
    (1..3).to_a.each do |site_id|
      ApplicationRecord.establish_connection_to_site(site_id)
      logs = logs + AccessLog.where(:fragment_id => fragement_id).where('created_at > ?', beta.hours.ago).to_a
    end
    logs
  end


end