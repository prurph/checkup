CheckUp::Application.routes.draw do
  devise_for :users

  post '/setup', to: 'pages#update'

  get '/setup',    to: 'pages#setup_page',    as: 'setup_path'
  get '/events',   to: 'pages#events_page',   as: 'events_path', defaults: { events: true }
  get '/routines', to: 'pages#routines_page', as: 'routines_path'
  root 'static_pages#home'
end
