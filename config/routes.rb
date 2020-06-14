Rails.application.routes.draw do
  root 'home#index'
  get 'stats' => 'home#stats'
  get 'search/people' => 'home#search_people', as: 'search_people'
  get 'search/buildings' => 'home#search_buildings', as: 'search_buildings'

  # get '/about' => 'home#about', as: 'about'
  get '/photos/:id/:style/:device' => 'buildings/main#photo', as: 'photo'

  get '/forge' => 'forge#index', as: 'forge'
  get '/forge/list' => 'forge#list', as: 'forge_list'

  devise_for :users,
             path: 'u',
             skip: [ :registerable, :confirmable ],
             controllers: { sessions: "sessions" } #, omniauth_callbacks: "omniauth_callbacks" }

  concern :people_directory do
    collection do
      get :advanced_search_filters
      get :building_autocomplete
      get :autocomplete
    end
    member do
      put :save_as
      put :reviewed
      put :make_person
    end
  end

  namespace :cms do
    resources :menus do
      resources :items, only: [:new, :create, :edit, :update, :destroy], controller: :menu_items
    end
    resources :pages
  end

  resources :buildings, controller: 'buildings/main' do
    collection do
      get :autocomplete
      get :advanced_search_filters
    end
    member do
      put :review
    end
    resources :photographs
    resources :merges, only: %i[new create], controller: 'buildings/merges'
  end

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

  resources :census_1940_records,
            concerns: [:people_directory],
            controller: 'people/census_records_nineteen_forty',
            path: 'census/1940',
            as: 'census1940_records'

  resources :contacts, only: %i[new create]
  get '/contact' => 'contacts#new'

  resources :flags

  resources :map_overlays

  resources :people, controller: 'people/main' do
    collection do
      get :advanced_search_filters
    end
    resources :merges, only: %i[new create], controller: 'people/merges'
  end

  resources :photographs do
    patch :review, on: :member
  end

  resources :street_conversions

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

  get 'uploads/pictures/:id/:style/:device' => 'cms/pictures#show', as: 'picture'

  match '*path'   => 'cms/pages#show', via: :all, constraints: -> (request) { request.format.html? && request.path != '/routes' }
end
