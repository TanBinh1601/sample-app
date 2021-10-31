Rails.application.routes.draw do
  get "static_pages/home"
  get "static_pages/help"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    resources :home
    root 'static_pages#home'
  end
end
