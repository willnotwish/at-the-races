Rails.application.routes.draw do
  resources :race_configs, path: 'race-configs' do
    resources :races, only: [:new]
  end

  resources :races, except: [:new]
  resources :race_results, only: %i[index show], path: 'race-results'

  root 'race_configs#index'
end
