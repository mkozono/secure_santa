class UsersController < ApplicationController

  def events
    redirect_to events_path and return unless authorized?
    @players = current_user.players
  end

  private

  def authorized?
    user_signed_in? && current_user.id.to_s == params[:user_id].to_s
  end
end