Dummy::Application.routes.draw do
  root :to => 'index#index'

  get 'index/get_detailed' => 'index#get_detailed'
  get 'index/set' => 'index#set'
  get 'index/get' => 'index#get'

  get 'index/get_controller' => 'index#get_controller'
  get 'index/get_defined' => 'index#get_defined'
end
