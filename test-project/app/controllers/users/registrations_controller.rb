class Users::RegistrationsController < Devise::RegistrationsController

  layout :choose_layout
  def choose_layout
    if params[:action] == 'edit' or params[:action] =='update' or params[:action] =='change_password'
      'users/default'
    else
      'users/login'
    end
  end

  before_filter :before_registration, :only => [:create]
  after_filter :after_registration, :only => [:create]

  expose(:auth){ current_account.authentications.find(session[:authentication]) if session[:authentication] }

  def new
    redirect_to users_contests_path if current_user
    resource = build_resource({})
  end

  def after_inactive_sign_up_path_for(resource)
    #users_thank_you_path
  end

  def after_sign_up_path_for(resource)
    sign_in(resource)
    #users_thank_you_path
  end

  def create
    build_resource(sign_up_params)
    resource.email = sign_up_params[:email]
    resource.password = sign_up_params[:password]
    resource.password_confirmation = sign_up_params[:password_confirmation]
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        if session[:authentication]
          Authentication.find(session[:authentication]).update_attribute(:user_id, resource.id) unless Authentication.find(session[:authentication]).user_id
        end
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  private
  def before_registration
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :username, :email, :password, :password_confirmation, :newsletter) }
  end

  def after_registration
    visitor_must_have_a_user
    user_receives_registration_coin_bonus
    update_contact_challenges_to_user if session[:challenge_id]
  end

  def visitor_must_have_a_user
    # Search visitors for user
    current_visitor.update_attribute(:user_id, current_user.id) if current_user && current_visitor.user_id == nil
  end
  def after_update_path_for(resource)
    #signed_in_root_path(resource)
    users_dashboard_path(resource)
  end

  def user_receives_registration_coin_bonus
    # @TODO unhardcode this value to current_account
    current_user.credit({:currency => 'RMBL', :amount => current_account.seed_with_coins, :message =>'Gift: New Account Coin Bonus'}) if current_user
  end

  def update_contact_challenges_to_user
    if session[:challenge_id] == nil
      if challenge = Challenge.find(session[:challenge_id])
        challenge.update_attributes(:opponent_id => current_user.id, :opponent_type => 'User')
      end
    end
  end
end

