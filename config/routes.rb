Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "movies/local", :action => "local_movies", :controller => "application"
  get "movies", :action => "all_movies", :controller => "application"
  get "movies/year/:year", :action => "movies_by_year", :controller => "application"

end
