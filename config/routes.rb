Rails.application.routes.draw do

  #get 'login', :to => "pages#login"
  get 'prospect', :to => "pages#prospect"
  get 'activity/:activity_id', :to => "pages#visits"


end
