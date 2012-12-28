Dummy::Application.routes.draw do
  resources :movies, :only => [:index, :show]
end
