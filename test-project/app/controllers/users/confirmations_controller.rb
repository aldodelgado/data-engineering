class Users::ConfirmationsController < Devise::ConfirmationsController
  layout 'users/login'
  protected
  def after_confirmation_path_for(resource_name, resource)
    if signed_in?
      if resource_name == :user
       new_session_path(resource_name)
      else
        signed_in_root_path(resource)
      end
    else
      new_session_path(resource_name)
    end
  end
end
