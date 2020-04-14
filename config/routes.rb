Rails.application.routes.draw do
  root 'home#index'
  get 'search/people' => 'home#search_people', as: 'search_people'
  get 'search/buildings' => 'home#search_buildings', as: 'search_buildings'

  # get '/about' => 'home#about', as: 'about'
  get '/photos/:id/:style/:device' => 'buildings#photo', as: 'photo'

  get '/forge' => 'forge#index', as: 'forge'
  get '/forge/list' => 'forge#list', as: 'forge_list'

  devise_for :users,
             path: 'u',
             skip: [ :registerable, :confirmable ],
             controllers: { sessions: "sessions" } #, omniauth_callbacks: "omniauth_callbacks" }

  resources :users do
    member do
      put 'enable'
      put 'disable'
      put 'disable_and_reset'
      get 'mask'
    end
    resource :user_account
    resources :roles
  end

  resources :vocabularies, only: :index do
    resources :terms do
      get 'peeps/:year' => 'terms#peeps'
      get 'peeps/:year/:page' => 'terms#peeps'
    end
  end

  resources :street_conversions

  resources :photographs do
    patch :review, on: :member
  end

  resources :buildings do
    collection do
      get :autocomplete
      get :advanced_search_filters
    end
    member do
      put :review
    end
    resources :photographs
  end

  concern :people_directory do
    collection do
      get :advanced_search_filters
      get :building_autocomplete
      get :autocomplete
    end
    member do
      put :save_as
      put :reviewed
    end
  end

  resources :map_overlays

  resources :census_1900_records,
            concerns: [:people_directory],
            controller: 'people/census_records_nineteen_aught',
            path: 'census/1900',
            as: 'census1900_records'

  resources :census_1910_records,
            concerns: [:people_directory],
            controller: 'people/census_records_nineteen_ten',
            path: 'census/1910',
            as: 'census1910_records'

  resources :census_1920_records,
            concerns: [:people_directory],
            controller: 'people/census_records_nineteen_twenty',
            path: 'census/1920',
            as: 'census1920_records'

  resources :census_1930_records,
            concerns: [:people_directory],
            controller: 'people/census_records_nineteen_thirty',
            path: 'census/1930',
            as: 'census1930_records'

end
