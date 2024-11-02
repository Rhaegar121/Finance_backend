Rails.application.routes.draw do
  get 'transactions/filter', to: 'transactions#filter'
  get 'transactions/search', to: 'transactions#search'

  resources :transactions
end