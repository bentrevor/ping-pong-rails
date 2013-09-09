PingPong::Application.routes.draw do
  get 'players/new'
  post 'players/create'
  get 'players/index'

  resources :games
  post 'games/finish'

  get 'matches/new'
  post 'matches/create'
  get 'matches/index'
  get 'matches/waiting_list'
  get 'matches/finished'
  get 'matches/:id', :to => 'matches#show'
end
