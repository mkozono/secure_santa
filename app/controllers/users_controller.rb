class UsersController < ApplicationController

  def events
    redirect_to events_path and return unless user_signed_in?
    @players = current_user.players.order('updated_at DESC')
  end
end