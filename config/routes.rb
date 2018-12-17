Rails.application.routes.draw do
  resources :answers
  resources :questions
  resources :users
  
  get "/questions/:question_id/answers", to: 'questions#answers'
  post '/sessions', to: 'authentication#authenticate'
  put "/questions/:id/resolve", to:'questions#resolve'
  post "/questions/:question_id/answers", to:'questions#create_answer'
  delete "/questions/:question_id/answers/:id", to: 'questions#delete_answer'
end
