class AccessLog < Movie
  self.table_name = 'access_log'

  def self.create_read_log(fragment_id, volume, current_site)
      AccessLog.create(site_id: current_site, rw: 0, fragment_id: fragment_id, volume: volume)
  end

  def self.create_write_log(fragment_id, volume, current_site)
      AccessLog.create(site_id: current_site, rw: 1, fragment_id: fragment_id, volume: volume)
  end
end