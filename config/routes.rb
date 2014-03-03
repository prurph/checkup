CheckUp::Application.routes.draw do
  devise_for :users

  patch '/setup/category', to: 'categories#update', as: 'update_category'
  post  '/setup/category', to: 'categories#create', as: 'new_category'

  get '/setup',    to: 'pages#setup_page',    as: 'setup'
  get '/events',   to: 'pages#events_page',   as: 'events', defaults: { events: true }
  get '/routines', to: 'pages#routines_page', as: 'routines'
  root 'static_pages#home'
end
