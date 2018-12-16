Rails.application.routes.draw do
  resources :answers
  resources :questions
  resources :users
  
  get "/questions/:question_id/answers", to: 'questions#answers'
end
