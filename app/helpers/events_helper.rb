module EventsHelper

    def user_role
      if params[:debug].present? && !Rails.env.production?
        User::ROLE_SITE_ADMIN
      else
        super
      end
    end

end
