class AuthenticationController < ApplicationController
  # skip_before_action :authenticate_request

  def authenticate 
    command = AuthenticateUser.call(params[:email], params[:password]) 

    if command.success? 
      user = User.find_by_email(params[:email])
      User.current = user
      user = ActiveModelSerializers::SerializableResource.new(user, adapter: :json).as_json[:user]
      render json: { auth_token: command.result, user:  user}
    else
      User.current = nil
      render json: { error: command.errors }, status: :unauthorized 
    end 
  end

  #TODO: Signout Implement it later for now only frontend implementation
end
