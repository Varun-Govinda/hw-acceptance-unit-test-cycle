Rottenpotatoes::Application.routes.draw do
  
  match '/movies/:id/same_director' => 'movies#same_director', via: [:get], :as => :same_director
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
end
