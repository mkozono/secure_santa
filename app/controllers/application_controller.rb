class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :store_location

  def store_location
    if (request.fullpath != "/sign_out" && !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath 
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    request.env['omniauth.origin'] || resource_or_scope
  end

  def after_sign_out_path_for(resource)
    session[:previous_url] || root_path
  end
end
