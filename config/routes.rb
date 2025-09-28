Rails.application.routes.draw do
  # === Vendor Authentication ===
  devise_for :vendors, controllers: {
    sessions: "vendors/sessions",
    registrations: "vendors/registrations",
    passwords: "vendors/passwords",
    confirmations: "vendors/confirmations",
    unlocks: "vendors/unlocks"
  }

  devise_scope :vendor do
    # STEP 1
    get  "/vendors/registrations/step1",      to: "vendors/registrations#step1",        as: :step1_vendor_registration
    post "/vendors/registrations/step1",      to: "vendors/registrations#step1_create", as: :create_step1_vendor_registration

    # STEP 2
    get  "/vendors/registrations/step2",      to: "vendors/registrations#step2",        as: :step2_vendor_registration
    post "/vendors/registrations/step2",      to: "vendors/registrations#step2_update", as: :update_step2_vendor_registration

    # STEP 3
    get  "/vendors/registrations/step3",      to: "vendors/registrations#step3",        as: :step3_vendor_registration
    post "/vendors/registrations/step3",      to: "vendors/registrations#step3_update", as: :update_step3_vendor_registration

    # STEP 4
    get  "/vendors/registrations/step4",      to: "vendors/registrations#step4",        as: :step4_vendor_registration
    post "/vendors/registrations/step4",      to: "vendors/registrations#step4_update", as: :update_step4_vendor_registration

    # COMPLETION
    get  "/vendors/registrations/complete",   to: "vendors/registrations#complete",     as: :complete_vendor_registration

    # Live email check
    get "/vendors/check_email", to: "vendors/registrations#check_email"
  end


  # === Vendor Registration Wizard ===
  resources :vendors, only: [:index, :show] do
    resources :vendor_reviews, only: [:create]
    resources :foods, only: [:show] 
    
  end

namespace :users do
  resources :conversations, only: [:index, :show, :create] do
    post :start, on: :collection
    resources :messages, only: [:create]
  end
end

  namespace :vendor do
    root "dashboard#index"
    get "dashboard", to: "dashboard#index"

    resources :conversations, only: [:index, :show, :new, :create] do
      resources :messages, only: [:create]
    end

    resources :orders, only: [:index, :show] do
      member { patch :mark_as_shipped }
    end

    resource :profile, only: [:edit, :update] do
      put :update_password, on: :collection
    end
     resources :foods
    resources :earnings, only: [:index]
    resource :settings, only: [:edit, :update]
    resources :notifications, only: [:index]
  end


  # === User Authentication (with Omniauth) ===
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  # === Public Site Pages ===
  root "landing#index"
  get "search", to: "landing#search"
  get "about",   to: "pages#about"
  get "contact", to: "pages#contact"

  # Categories & Foods
  resources :categories, only: [:index, :show]

  # 🚨 Removed global foods :show route
  resources :foods, only: [:index, :show] do
    resources :reviews, only: [:new, :create]
  end

  # Optional: separate controllers for small_chops & drinks (if necessary)
  resources :small_chops, only: [:index, :show]
  resources :drinks, only: [:index, :show]

  # Orders & Checkout
  resources :orders, only: [:new, :create, :show, :index] do
    collection { get :export_csv }
    member do
      get :message_admin
      get :download_summary
    end
  end

  resource :checkout, only: [:show, :create]
  resource :cart, only: [:show] do
    post   "add_item/:id",    to: "carts#add_item",    as: :add_item
    delete "remove_item/:id", to: "carts#remove_item", as: :remove_item
    get    "checkout",        to: "carts#checkout",   as: :checkout
  end
  resources :cart_items, only: [:create, :update, :destroy]

  # Payment
  post "paystack/checkout", to: "payments#pay",    as: :paystack_checkout
  get  "/verify",           to: "payments#verify", as: :verify_payment

  # === Admin Namespace ===
  namespace :admin do
    get "dashboard", to: "dashboard#index", as: "dashboard"

    resources :vendors do
      member do
        patch :approve
        patch :reject
      end
    end


    resources :vendors, only: [:index, :show] do
  resources :foods, only: [:show]
end
    resources :users, only: [:index, :show, :destroy]
    resources :reports, only: [:index]

    resources :categories
    resources :foods do
      resources :reviews, only: [:create]
    end

    resources :orders, only: [:index, :show, :update] do
      patch :update_status, on: :member
    end
  end

  resources :support_tickets, only: [:new, :create, :show, :index]

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Dev-only tools
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
