class Users::ProfileController < UsersController
  before_filter :check_password_submitted, :only => :update
  expose(:user){ current_user }

  def update
    if user.update_attributes(params[:user])
      sign_in(current_user, :bypass => true)
      flash[:notice] = t(:profile_was_successfully_updated)
      redirect_to users_contests_path
    else
      render :edit
    end
  end

  private
  def check_password_submitted
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
      user.updating_password = false
    else
      user.updating_password = true
    end
  end
end
