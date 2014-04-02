class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def failure
    sign_out :user
    redirect_to new_user_session_path, :flash => {:error => t(:sorry_we_could_not_log_you_in)}
  end

  def login
    auth = find_auth
    Rails.logger.info("auth is **************** #{auth.to_yaml}")
    if auth && auth.user_id? && auth.user.persisted?
      if current_user
        redirect_to users_authentications_path
      else
        sign_in(auth.user , :bypass => true)
        redirect_to users_contests_path
      end
    else
      new_account
    end
  end

  def facebook
    login
  end

  def twitter
    login
  end

  def google_oauth2
    login
  end

  def find_auth
    a = Authentication.find_or_initialize_by(:provider => request.env['omniauth.auth']["provider"], :uid => request.env['omniauth.auth']["uid"], :account_id => current_account.id)
    a.auth = request.env['omniauth.auth']
    if request.env['omniauth.auth']["provider"] == 'facebook'
      a.username                = request.env['omniauth.auth'].try(:[],'info').try(:[],'nickname')
      a.first_name              = request.env['omniauth.auth'].try(:[],'info').try(:[],'first_name')
      a.last_name               = request.env['omniauth.auth'].try(:[],'info').try(:[],'last_name')
      a.full_name               = request.env['omniauth.auth'].try(:[],'info').try(:[],'name')
      a.profile_image_url       = request.env['omniauth.auth'].try(:[],'info').try(:[],'image')
      a.url                     = request.env['omniauth.auth'].try(:[],'info').try(:[],'urls').try(:[],'Facebook')
      a.email                   = request.env['omniauth.auth'].try(:[],'info').try(:[],'email')
      a.current_location        = request.env['omniauth.auth'].try(:[],'info').try(:[],'location')
      a.token                   = request.env['omniauth.auth'].try(:[],'credentials').try(:[],'token')
      a.token_expires_at        = request.env['omniauth.auth'].try(:[],'credentials').try(:[],'expires_at')
      a.gender                  = request.env['omniauth.auth'].try(:[],'extra').try(:[],'raw_info').try(:[],'gender')
      a.interested_in           = request.env['omniauth.auth'].try(:[],'extra').try(:[],'raw_info').try(:[],'interested_in').join(',') if request.env['omniauth.auth'][:extra][:raw_info][:interested_in]
      a.hometown                = request.env['omniauth.auth'].try(:[],'extra').try(:[],'raw_info').try(:[],'hometown').try(:[],'name')
      a.religion                = request.env["omniauth.auth"].try(:[],'extra').try(:[],'raw_info').try(:[],'religion')
      a.relationship_status     = request.env["omniauth.auth"].try(:[],'extra').try(:[],'raw_info').try(:[],'relationship_status')
      if request.env['omniauth.auth'][:extra][:raw_info][:birthday]
        a.birthday                = Date.strptime(request.env['omniauth.auth'][:extra][:raw_info][:birthday], "%m/%d/%Y") unless request.env['omniauth.auth'][:extra][:raw_info][:birthday].empty?
      end
    elsif request.env['omniauth.auth']["provider"] == 'twitter'
      a.username                = request.env['omniauth.auth'].try(:[],'info').try(:[],'nickname')
      a.full_name               = request.env['omniauth.auth'].try(:[],'info').try(:[],'name')
      name_splitter             = FullNameSplitter::Splitter.new(a.full_name)
      a.first_name              = name_splitter.first_name
      a.last_name               = name_splitter.last_name
      a.profile_image_url       = request.env['omniauth.auth'].try(:[],'info').try(:[],'image')
      a.url                     = request.env['omniauth.auth'].try(:[],'info').try(:[],'urls').try(:[],'Twitter')
      a.token                   = request.env['omniauth.auth'].try(:[],'credentials').try(:[],'token')
      a.secret                  = request.env['omniauth.auth'].try(:[],'credentials').try(:[],'secret')
      a.followers_count         = request.env['omniauth.auth'].try(:[],'extra').try(:[],'raw_info').try(:[],'followers_count')
      a.friends_count           = request.env['omniauth.auth'].try(:[],'extra').try(:[],'raw_info').try(:[],'friends_count')
    elsif request.env['omniauth.auth']["provider"] == 'google_oauth2'
      a.username =
      a.first_name = request.env['omniauth.auth'].try(:[],'info').try(:[],'first_name')
      a.last_name = request.env['omniauth.auth'].try(:[],'info').try(:[],'last_name')
      a.full_name = request.env['omniauth.auth'].try(:[],'info').try(:[],'name')
      a.email = request.env['omniauth.auth'].try(:[],'info').try(:[],'email')
      a.token = request.env['omniauth.auth'].try(:[],'credentials').try(:[],'token')
      a.token_expires_at = request.env['omniauth.auth'].try(:[],'credentials').try(:[],'expires_at')
    end
    user = current_account.users.find_by_email(a.email)
    a.user_id = user.id if user
    if a && a.user_id== nil && current_user
      a.user_id = current_user.id
    end
    a.save!
    a
  end

  def new_account
    a = find_auth
    session[:authentication] = a.id
    #session["devise.#{request.env['omniauth.auth']['provider']}_uid"] = request.env['omniauth.auth'][:uid]
    #session["devise.#{request.env['omniauth.auth']['provider']}_data"] = request.env['omniauth.auth']
    redirect_to new_user_registration_path
  end

  #def facebook
   #@user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

   #if @user.persisted?
   #  sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
   #  set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
   #else
   #  session["devise.facebook_data"] = request.env["omniauth.auth"]
   #  redirect_to new_user_registration_url
   #end
 #end
 #def google_oauth2
 #    # You need to implement the method below in your model (e.g. app/models/user.rb)
 #    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)

 #    if @user.persisted?
 #      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
 #      sign_in_and_redirect @user, :event => :authentication
 #    else
 #      session["devise.google_data"] = request.env["omniauth.auth"]
 #      redirect_to new_user_registration_url
 #    end
 #end

end
