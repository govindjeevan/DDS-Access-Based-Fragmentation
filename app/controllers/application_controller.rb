class ApplicationController < ActionController::Base
  before_action :resolve_site, :connect_to_site

  def local_movies
    @local_movies = Movie.all
  end

  def movies_by_year
    @movies = Movie.fetch_fragment(params[:year])
    render 'application/movies'
  end

  def all_movies
    ApplicationRecord.establish_connection_to_site(1)
    @all_movies = Movie.all
    ApplicationRecord.establish_connection_to_site(2)
    @all_movies = @all_movies + Movie.all
    ApplicationRecord.establish_connection_to_site(3)
    @all_movies = @all_movies + Movie.all
    ApplicationRecord.establish_connection_to_site(@site)
  end

  private

  def resolve_site
    @site = 1
  end

  def connect_to_site
    ApplicationRecord.establish_connection_to_site(@site)
  end

end