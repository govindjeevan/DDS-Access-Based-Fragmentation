class SiteZMovie < SiteZRecord
  self.table_name = "movies"

  def year
    self.release_date.year
  end

end
