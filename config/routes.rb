ExpirySyncServer::Application.routes.draw do
  resources :article_images

  resources :producers

  devise_for :users, controllers: {sessions: "sessions", registrations: "registrations"}
  
  resources :articles
  get 'articles/by_barcode/:barcode' => 'articles#by_barcode'
  
  resources :product_entries, only: [:create, :update, :destroy]
  
  resources :locations do
    get "index_mine_changed", on: :collection
    resources :product_entries do
      get "index_changed", on: :collection
    end
  end
  
  resources :article_images do
    get "serve", :on => :member
  end
end
