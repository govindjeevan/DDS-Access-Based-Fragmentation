class ApplicationController < ActionController::Base
  before_action :resolve_site, :connect_to_site

  def local_movies
    @movies = Movie.all
    render 'application/movies'
  end

  def movies_by_site
    @movies2 = Movie.movies_by_site(params[:site])
    render 'application/movies2'
  end

  def movies_by_year
    @movies = Movie.fetch_fragment(params[:year], @site)
    render 'application/movies'
  end

  def all_movies
    ApplicationRecord.establish_connection_to_site(1)
    @movies = Movie.all
    ApplicationRecord.establish_connection_to_site(2)
    @movies += Movie.all
    ApplicationRecord.establish_connection_to_site(3)
    @movies += Movie.all
    ApplicationRecord.establish_connection_to_site(@site)
    render 'application/movies'

  end

  private

  def resolve_site
    @site = 3
  end

  def connect_to_site
    ApplicationRecord.establish_connection_to_site(@site)
  end

end