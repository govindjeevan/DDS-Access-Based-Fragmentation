class Movie < ApplicationRecord

  def self.count
    SiteXMovie.count + SiteYMovie.count + SiteZMovie.count
  end


  def self.all
    SiteXMovie.all + SiteYMovie.all + SiteZMovie.all
  end



end