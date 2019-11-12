Rails.application.routes.draw do
  get  '/',                   to: 'posts#home'

  get  '/posts',              to: 'posts#index'
  get  '/posts/new',          to: 'posts#new'
  post '/posts/create',       to: 'posts#create'

  post '/posts/reply',        to: 'posts#reply'

  get  '/posts/bookmark',     to: 'posts#bookmark'
  post '/posts/add_bookmark', to: 'posts#addBookmark'

  get  '/posts/:id',          to: 'posts#read'
  post '/posts/:id/edit',     to: 'posts#edit'
  post '/posts/:id/delete',   to: 'posts#delete'
  post '/posts/:id/update',   to: 'posts#update'
end
