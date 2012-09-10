Dummy::Application.routes.draw do
  root :to => 'index#index'

  get 'index/get' => 'index#get'
  get 'index/set' => 'index#set'
end
