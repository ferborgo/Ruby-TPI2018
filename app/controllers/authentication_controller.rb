class AuthenticationController < ApplicationController
 #skip_before_action :authenticate_request

 def authenticate
   command = AuthenticateUser.call(params[:email], params[:password])

   if command.success?
   	user = User.find_by_email(params[:email])
   	json_string = UserSerializer.new([user],{params:{token: command}}).serialized_json
    render json: json_string
     #render json: { auth_token: command.result, user:user }
   else
     render json: { error: command.errors }, status: :unauthorized
   end
 end
end