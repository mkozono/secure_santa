class PlayersController < ApplicationController

  def show
    @player = Player.find_by_id(params[:id])
    if @player.present?
      if user_signed_in? && current_user == @player.user
        redirect_to verified_player_path(@player.uid) and return
      elsif @player.uid.present?
        redirect_to @player.event, notice: "Player #{@player.name} has already claimed their secret page!" and return
      end
      render :show
    else
      if params[:event_id] && (event = Event.find_by_id(params[:event_id]))
        flash[:notice] = "Could not find player."
        redirect_to event and return
      end
      flash[:notice] = "Could not find event."
      redirect_to events_path and return
    end
  end

  def show_verified
    @player = Player.find_by_uid(params[:uid])
    if @player.nil?
      flash[:notice] = "Could not find player."
      redirect_to events_path and return
    end
  end

  def confirm
    event = Event.find_by_id(params[:event_id])
    player = Player.find_by_id(params[:id])
    redirect_to events_path, error: "Could not claim player in different event." and return if player.event_id != event.id
    redirect_to player.event, notice: "Player #{player.name} has already claimed their secret page!" and return if player.claimed?
    return claim_and_redirect_to(player)
  end

  def reset_player
    event = Event.find_by_admin_uid(params[:admin_uid])
    player = Player.find_by_uid(params[:uid])
    if event && player && player.event_id == event.id
      player.update_attributes!(:uid => nil, :user_id => nil)
      redirect_to event_admin_path(event.admin_uid)
    end
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
      if user_signed_in?
        player.set_uid
        player.user = current_user
        player.save!
        flash[:notice] = "Successfully claimed player #{player.name}!"
        redirect_to verified_player_path(player.uid)
      else
        player.set_uid
        player.save!
        flash[:notice] = "Bookmark this secret page, there is no other way to get to it later!"
        redirect_to verified_player_path(player.uid)
      end
    end

end
