PingPong::Application.routes.draw do
  get 'players/new', :as => 'players'
  post 'players/create'
  get 'players/index'

  get 'games/new'
  post 'games/create'
  get 'games/index'

  get 'matches/new'
  post 'matches/create'
  get 'matches/index'
  get 'matches/waiting_list'
  get 'matches/finished'
end
