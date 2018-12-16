class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :username, :screen_name, :email, :password
  has_many :questions
  has_many :answers
end
