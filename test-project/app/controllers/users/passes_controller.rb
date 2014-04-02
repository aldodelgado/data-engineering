class Users::PassesController < UsersController
  expose(:pass, attributes: :pass_params){ current_user}

  def update
    if pass_params[:password].blank?
      pass_params.delete("password")
      pass_params.delete("password_confirmation")
    end

    if pass.update_attributes(pass_params)
      sign_in pass, :bypass => true
      redirect_to users_my_profile_path
    else
      render "edit"
    end
  end

  private
  def pass_params
    params.require(:user).permit(:password,:password_confirmation)
  end
end


