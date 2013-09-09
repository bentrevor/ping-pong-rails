PingPong::Application.routes.draw do
  get 'players/new'
  post 'players/create'
  get 'players/index'

  resources :games
  post 'games/finish'

  get 'matches/waiting_list'
  get 'matches/finished'
  post 'matches/finish'
  resources :matches
end
