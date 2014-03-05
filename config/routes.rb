CheckUp::Application.routes.draw do
  devise_for :users

  get   '/routines/get_event', to: 'events#show', as: 'event_show'
  post  '/routines/tag_event', to: 'tags#tag_event', as: 'tag_event'

  patch '/setup/tag',      to: 'tags#update',       as: 'update_tag'
  post  '/setup/tag',      to: 'tags#create',       as: 'new_tag'
  patch '/setup/category', to: 'categories#update', as: 'update_category'
  post  '/setup/category', to: 'categories#create', as: 'new_category'

  patch '/setup/save_routine', to: 'tags#save_routine', as: 'save_routine'

  get '/setup',    to: 'pages#setup_page',    as: 'setup'
  get '/events',   to: 'pages#events_page',   as: 'events', defaults: { events: true }
  get '/routines', to: 'pages#routines_page', as: 'routines'
  root 'static_pages#home'
end
