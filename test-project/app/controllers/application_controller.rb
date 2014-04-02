class ApplicationController < ActionController::Base
  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  before_filter :set_locale

  def set_locale
    if params[:lang]
      session[:lang] = params[:lang]
    end
    I18n.locale = session[:lang] || I18n.default_locale
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
