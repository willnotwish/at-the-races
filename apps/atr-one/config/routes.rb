Rails.application.routes.draw do
  resources :race_configs, path: 'race-configs' do
    resources :races, only: [:new]
  end

  resources :races, except: [:new]
  post 'races/:id/start', to: 'races#start', as: 'start_race'

  resources :race_results, only: %i[index show], path: 'race-results' do
    resources :counter_updates, only: %i[index show], path: 'counter-updates', shallow: true
  end

  root 'race_configs#index'
end
