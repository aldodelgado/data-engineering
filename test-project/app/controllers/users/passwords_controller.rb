class Users::PasswordsController < Devise::PasswordsController
  layout 'users/login'

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      sign_in(resource_name, resource)
      if resource_name == :user
        respond_with resource, :location => users_contests_path
      else
        respond_with resource, :location => after_resetting_password_path_for(resource)
      end
    else
      respond_with resource
    end
  end
end

