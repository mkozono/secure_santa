class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      session[:avatar_url] = request.env["omniauth.auth"].info.image
      flash.notice = "Signed in successfully!"
      sign_in_and_redirect user
    else
      redirect_to events_path, error: "Error while signing in."
    end
  end

  alias_method :facebook, :all
end