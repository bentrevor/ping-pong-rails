PingPong::Application.routes.draw do

  root :to => redirect('/matches/waiting_list')

  resources :players, :only => [:show, :index]

  resources :games
  post 'games/finish'

  get 'matches/waiting_list'
  get 'matches/finished'
  post 'matches/start'
  resources :matches
end
