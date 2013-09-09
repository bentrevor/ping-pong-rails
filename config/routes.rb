PingPong::Application.routes.draw do
  get 'players/new'
  post 'players/create'
  get 'players/index'

  get 'games/new'
  post 'games/create'
  get 'games/index'
  post 'games/finish'
  post 'games/update'
  get 'games/:id', :to => 'games#show'

  get 'matches/new'
  post 'matches/create'
  get 'matches/index'
  get 'matches/waiting_list'
  get 'matches/finished'
  get 'matches/:id', :to => 'matches#show'
end
