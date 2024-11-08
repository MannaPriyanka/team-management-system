# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: { message: 'Signed in successfully', user: resource }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: { message: 'Signed out successfully' }, status: :ok
    else
      render json: { message: 'User not found or not logged in' }, status: :unauthorized
    end
  end
end
