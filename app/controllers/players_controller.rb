class PlayersController < ApplicationController

  def show
    @player = Player.find_by_id(params[:id])
    redirect_to event_path(params[:event_id]), error: "Could not find player." and return unless @player
    redirect_to verified_player_path(@player.uid) and return if user_signed_in? && current_user == @player.user      
    redirect_to @player.event, notice: "Player #{@player.name} has already claimed their secret page!" and return if @player.uid
    render :show
  end

  def show_verified
    @player = Player.find_by_uid(params[:uid])
    if @player.nil?
      flash[:notice] = "Could not find player."
      redirect_to events_path and return
    end
  end

  def confirm
    player = Player.find_by_id_and_event_id(params[:id], params[:event_id])
    redirect_to events_path, error: "Could not find player." and return unless player
    redirect_to player.event, notice: "Player #{player.name} has already claimed their secret page!" and return if player.claimed?
    return claim_and_redirect_to(player)
  end

  def reset_player
    event = Event.find_by_admin_uid(params[:admin_uid])
    redirect_to events_path, error: "Could not find event." and return unless event
    player = Player.find_by_uid(params[:uid])
    redirect_to event, error: "Could not find player." and return unless player
    player.update_attributes!(:uid => nil, :user_id => nil)
    redirect_to event_admin_path(event.admin_uid)
  end

  def update_verified
    player = Player.find_by_uid(params[:uid])
    if player.update_attributes(update_params)
      redirect_to verified_player_path(player.uid), notice: "Successfully updated player." and return
    else
      flash[:error] = "Unable to save edits."
      render :show_verified
    end
  end

  private

    def update_params
      params.require(:player).permit(:message)
    end

    def claim_and_redirect_to(player)
      player.set_uid

      if user_signed_in?
        player.user = current_user
        flash[:notice] = "Successfully claimed player #{player.name}!"
      else
        flash[:notice] = "Bookmark this secret page, there is no other way to get to it later!"
      end

      player.save!
      redirect_to verified_player_path(player.uid)
    end

end
