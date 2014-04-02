class Users::SessionsController < Devise::SessionsController
  layout 'users/login'

  before_filter :before_signin, :only => [:create]
  after_filter :after_signin, :only => [:create]

  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    respond_with(resource, serialize_options(resource))
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    #set_flash_message(:notice, :signed_in) if is_flashing_format?
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

  def before_signin
  end
  def after_signin
   if session[:challenge_token]
     if challenge = Challenge.find_by_token(session[:challenge_token])
       if current_user && current_user.id == challenge.opponent_id
         if current_user.debit({:contest_id => challenge.contest.id, :currency => challenge.contest.game_type, :amount => challenge.contest.entry_fee, :message =>'Contest Entry Fee'})
           challenge.update_attribute(:status, 'accepted')
           Entry.create(:user_id => current_user.id, :contest_id => challenge.contest.id, :status => 'pending')
           #redirect_to drafts_users_contest_path(challenge.contest)
           return false
         else
           #redirect_to users_add_payment_path
           return false
         end # current_user.debit({:contest_id => challenge.contest.id, :currency => challenge.contest.game_type, :amount => challenge.contest.entry_fee, :message =>'Contest Entry Fee'})
       end # current_user && current_user.id == challenge.opponent_id
     end #challenge = Challenge.find_by_token(session[:challenge_token])
   end # session[:challenge_token]
  end
end

