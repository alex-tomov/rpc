Rails.application.routes.draw do
  root 'competitions#index'

  resource :competitions do
    get :index
    get :play
  end
end
