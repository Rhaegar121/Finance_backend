Rails.application.routes.draw do
  get 'transactions/filter', to: 'transactions#filter'
  get 'transactions/search', to: 'transactions#search'
  get 'transactions/yearly_summary', to: 'transactions#yearly_summary'

  resources :transactions
end