class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :username, :screen_name, :email, :password
  has_many :questions
  has_many :answers
  attribute :token

  attribute :token do |user,params|
  	params[:token] ? params[:token].result : nil
  end
end
