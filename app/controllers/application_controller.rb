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
    x = Movie.fetch_fragment_by_year(params[:year], @site)
    @movies = x[0]
    @time = x[1]
    render 'application/movies'
  end

  def movies_by_time_range
    if params[:start_time] && params[:end_time]
      @movies = Movie.fetch_fragment_by_time(DateTime.parse(params[:start_time]), DateTime.parse(params[:end_time]), @site)
    else
      @movies = Movie.movies_by_site(@site)
    end
    render 'application/movies_by_time_range'
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