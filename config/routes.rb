Rails.application.routes.draw do
  get  '/posts',          to: 'posts#index'
  get  '/posts/:id',      to: 'posts#read'
  post '/posts/:id/edit', to: 'posts#edit'
  post '/posts/create',   to: 'posts#create'
end
