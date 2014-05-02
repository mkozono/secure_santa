module EventsHelper

    def player_role
      if params[:debug].present? && !Rails.env.production?
        Player::ROLE_SITE_ADMIN
      elsif params[:admin_uid]
        Player::ROLE_EVENT_ADMIN
      else
        super
      end
    end

end
