class Users::AuthenticationsController < UsersController
  expose(:authentications){ current_user.authentications }
  expose(:authentication, attributes: :authentication_params)

  def create
    authentication.account_id = current_account.id
    authentication.user_id = current_user.id
    if authentication.save
      flash[:notice] = "Authentication Created"
      redirect_to users_authentications_path
    else
      render :new
    end
  end

  def update
    if authentication.save
      flash[:notice] = "Authentication Updated"
      redirect_to users_authentications_path
    else
      render :edit
    end
  end

  def destroy
    authentication.destroy
    flash[:notice] = 'Authentication Deleted'
    redirect_to users_authentications_path
  end

  private
  def contest_params
   #params.require(:authentication).permit(
   # :sport_id,
   # :name,
   # :description,
   # :is_public,
   # :contest_type,
   # :starts_at,
   # :ends_at
   #)
    params.require(:authentication).permit!
  end
end
