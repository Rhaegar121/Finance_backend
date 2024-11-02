Rails.application.routes.draw do
  get 'transactions/by_month', to: 'transactions#by_month'
  get 'transactions/by_date_range', to: 'transactions#by_date_range'
  get 'transactions/search', to: 'transactions#search'
  post 'transactions', to: 'transactions#create'
  delete 'transactions/:id', to: 'transactions#destroy'
end