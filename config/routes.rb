PingPong::Application.routes.draw do

  root :to => redirect('/matches/waiting_list')

  resources :players, :only => [:show, :index]

  resources :games
  post 'games/finish'

  get 'matches/waiting_list'
  get 'matches/finished'
  get 'matches/in_progress'
  post 'matches/:id/start', :to => 'matches#start', :as => :matches_start
  resources :matches
end
