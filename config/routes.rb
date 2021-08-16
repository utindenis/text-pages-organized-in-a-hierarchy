Rails.application.routes.draw do
  resources :categories

  root to: 'categories#index'
  get 'index', to: 'categories#index'

  get 'add', to: 'categories#new'
  get ':alias/add', to: 'categories#new', constraints: { alias: /.*/ }

  post 'create', to: 'categories#create'
  post ':alias/create', to: 'categories#create', constraints: { alias: /.*/ }

  get 'edit', to: 'categories#edit'
  get ':alias/edit', to: 'categories#edit', constraints: { alias: /.*/ }

  put 'update', to: 'categories#update'
  put ':alias/update', to: 'categories#update', constraints: { alias: /.*/ }

  delete 'delete', to: 'categories#destroy'
  delete ':alias/delete', to: 'categories#destroy', constraints: { alias: /.*/ }

  get ':alias', to: 'categories#show', constraints: { alias: /.*/ }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
