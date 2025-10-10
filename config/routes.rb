Rails.application.routes.draw do
  
  # === Rider Authentication ===
  devise_for :riders, class_name: 'Rider', controllers: {
    sessions: 'riders/sessions',
    registrations: 'riders/registrations'
  }

  # Rider dashboard (after login)
  devise_scope :rider do
    authenticated :rider do
      get '/rider/dashboard', to: 'rider_dashboard/dashboard#index', as: :rider_dashboard
    end
  end  # <-- ✅ this was missing

  # === Vendor Promotion routes ===
  namespace :vendors do
    get "promotions/index"
    get "promotions/new"
    get "promotions/create"
    get "promotions/edit"
    get "promotions/update"
    get "promotions/destroy"
  end

  # === Vendor Authentication (Devise) ===
  devise_for :vendors, 
             class_name: "Vendor", controllers: {
               sessions: "vendors/sessions",
               registrations: "vendors/registrations",
               passwords: "vendors/passwords",
               confirmations: "vendors/confirmations",
               unlocks: "vendors/unlocks"
             }

  # === Rider Registration Steps ===
  devise_scope :rider do
    get  "/riders/registrations/step1", to: "riders/registrations#step1", as: :step1_rider_registration
    post "/riders/registrations/step1", to: "riders/registrations#step1_create"

    get  "/riders/registrations/step2", to: "riders/registrations#step2", as: :step2_rider_registration
    patch "/riders/registrations/step2", to: "riders/registrations#step2_update"

    get  "/riders/registrations/step3", to: "riders/registrations#step3", as: :step3_rider_registration
    patch "/riders/registrations/step3", to: "riders/registrations#step3_update"

    get  "/riders/registrations/step4", to: "riders/registrations#step4", as: :step4_rider_registration
    patch "/riders/registrations/step4", to: "riders/registrations#step4_update"

    get  "/riders/registrations/complete", to: "riders/registrations#complete", as: :complete_rider_registration
  end

  # === Vendor Registration Steps ===
  devise_scope :vendor do
    get  "/vendors/registrations/step1", to: "vendors/registrations#step1", as: :step1_vendor_registration
    post "/vendors/registrations/step1", to: "vendors/registrations#step1_create", as: :create_step1_vendor_registration
    get  "/vendors/registrations/step2", to: "vendors/registrations#step2", as: :step2_vendor_registration
    post "/vendors/registrations/step2", to: "vendors/registrations#step2_update", as: :update_step2_vendor_registration
    get  "/vendors/registrations/step3", to: "vendors/registrations#step3", as: :step3_vendor_registration
    post "/vendors/registrations/step3", to: "vendors/registrations#step3_update", as: :update_step3_vendor_registration
    get  "/vendors/registrations/step4", to: "vendors/registrations#step4", as: :step4_vendor_registration
    post "/vendors/registrations/step4", to: "vendors/registrations#step4_update", as: :update_step4_vendor_registration
    get  "/vendors/registrations/complete", to: "vendors/registrations#complete", as: :complete_vendor_registration

    # Live email check
    get "/vendors/check_email", to: "vendors/registrations#check_email"
  end

  # === Rider Dashboard ===
  namespace :rider_dashboard do
    get 'pending', to: 'dashboard#pending', as: :pending
    patch 'locations/update', to: 'locations#update'
    patch 'orders/:id/accept', to: 'orders#accept', as: 'accept_order'
    patch 'orders/:id/start', to: 'orders#start', as: 'start_order'
    patch 'orders/:id/complete', to: 'orders#complete', as: 'complete_order'

    resources :locations, only: [:update]
    resources :orders, only: [] do
      patch :update_status, on: :member
    end
  end

  # === Public-facing Vendors & Foods ===
  namespace :public, path: "" do
    resources :categories, only: [] do
      resources :foods, only: [:index], param: :subcategory_id
    end

    resources :vendors, only: [:index, :show] do
      resources :foods, only: [:index, :show], shallow: true
      resources :vendor_reviews, only: [:create]
    end

    resources :foods, only: [:index, :show] do
      resources :reviews, controller: "food_reviews", only: [:new, :create]
    end
  end

  # === Vendor Dashboard (CRUD & management) ===
  namespace :vendor do
    root "dashboard#index"
    get "dashboard", to: "dashboard#index"

    resources :foods do
      member do
        patch :toggle_status
        patch :toggle_stock
      end
    end

    resource :profile, only: [:edit, :update] do
      put :update_password, on: :collection
    end

    resources :promotions, except: [:show] do
      member { patch :toggle_status }
    end

    resources :orders, only: [:index, :show] do
      member { patch :mark_as_shipped }
       
    end

    resources :conversations, only: [:index, :show, :new, :create] do
      resources :messages, only: [:create]
    end

    resources :earnings, only: [:index]
    resource :settings, only: [:edit, :update]
    resources :notifications, only: [:index]
  end

  # === User Authentication ===
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  # === Public Pages ===
  root "landing#index"
  get "search",  to: "landing#search"
  get "about",   to: "pages#about"
  get "contact", to: "pages#contact"
  get "terms",   to: "pages#terms", as: "terms"

  resources :categories, only: [:index, :show]
  resources :small_chops, only: [:index, :show]
  resources :drinks, only: [:index, :show]

  # === Orders & Checkout ===
  resources :orders, only: [:new, :create, :show, :index] do
    collection { get :export_csv }
    member do
      get :message_admin
      get :track
      get :download_summary
    end
  end

  resource :checkout, only: [:show, :create]

  resource :cart, only: [:show] do
    post "cart/add/:food_id", to: "carts#add", as: "cart_add"
    delete "remove_item/:id", to: "carts#remove_item", as: :remove_item
    get "checkout", to: "carts#checkout", as: :checkout
  end

  resources :cart_items, only: [:create, :update, :destroy]

  # === Payment ===
  post "paystack/checkout", to: "payments#pay", as: :paystack_checkout
  get  "/verify", to: "payments#verify", as: :verify_payment

  # === Admin Namespace ===
  namespace :admin do
    get "dashboard", to: "dashboard#index", as: "dashboard"

    resources :vendors do
      member do
        patch :approve
        patch :reject
      end
      resources :foods, only: [:show]
    end

    resources :users, only: [:index, :show, :destroy]
    resources :reports, only: [:index]
    resources :categories
    resources :promotions

    resources :foods do
      resources :reviews, only: [:create]
    end

    resources :orders, only: [:index, :show, :update] do
      patch :update_status, on: :member
    end

    resources :support_tickets, only: [:index, :show, :update]

    resources :riders do
      member do
        patch :approve
        patch :reject
        patch :verify
        patch :unverify
        patch :suspend
        patch :unsuspend
      end
    end
  end

  namespace :users do
    resources :conversations, only: [:index, :show, :create] do
      post :start, on: :collection
      resources :messages, only: [:create]
    end
  end

  # === Support Tickets ===
  resources :support_tickets, only: [:new, :create, :show, :index]

  # === Health Check ===
  get "up" => "rails/health#show", as: :rails_health_check

  # === Dev-only Tools ===
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
