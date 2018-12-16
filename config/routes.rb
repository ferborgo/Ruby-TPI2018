Rails.application.routes.draw do
  resources :answers
  resources :questions
  resources :users
  
  get "/questions/:question_id/answers", to: 'questions#answers'
  post '/sessions', to: 'authentication#authenticate'
end
