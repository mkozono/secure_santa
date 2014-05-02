class PlayersController < ApplicationController

  def show
    @player = Player.find_by_id(params[:id])
    if @player.present?
      if @player.uid.present?
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
    if event && player && player.event_id == event.id
      if player.uid.blank?
        player.set_uid
        player.save!
        flash[:notice] = "Bookmark this secret page, there is no other way to get to it later!"
        redirect_to verified_player_path(player.uid) and return
      else
        redirect_to player.event, notice: "Player #{player.name} has already claimed their secret page!" and return
      end
    end
    redirect_to events_path, error: "Could not confirm player." and return
  end

  def reset_player
    event = Event.find_by_admin_uid(params[:admin_uid])
    player = Player.find_by_uid(params[:uid])
    if event && player && player.event_id == event.id
      player.update_attributes!(:uid => nil)
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

end
