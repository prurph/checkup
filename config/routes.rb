CheckUp::Application.routes.draw do
  devise_for :users

  post '/routines/set-event/:id', to: 'tags#set', as: 'set_tag'

  patch '/setup/category/:id', to: 'categories#update', as: 'update_category'
  post  '/setup/category', to: 'categories#create', as: 'new_category'

  get '/setup',    to: 'pages#setup_page',    as: 'setup'
  get '/events',   to: 'pages#events_page',   as: 'events', defaults: { events: true }
  get '/routines', to: 'pages#routines_page', as: 'routines'
  root 'static_pages#home'
end
