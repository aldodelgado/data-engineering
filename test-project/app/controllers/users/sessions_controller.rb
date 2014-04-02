class Users::SessionsController < Devise::SessionsController

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    yield resource if block_given?
    if session[:user_return_to]
      respond_with resource, :location => session[:user_return_to]
    else
      respond_with resource, :location => after_sign_in_path_for(resource)
    end
  end

  private
  def after_sign_in_path_for(resource)
    users_root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
