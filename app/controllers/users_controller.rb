class UsersController < ApplicationController

  def show
    @user = User.find_by_id(params[:id])
    if @user.present?
      if @user.uid.present?
        redirect_to @user.event, notice: "User #{@user.name} has already claimed their secret page!" and return
      end
      render :show
    else
      if params[:event_id] && (event = Event.find_by_id(params[:event_id]))
        flash[:notice] = "Could not find user."
        redirect_to event and return
      end
      flash[:notice] = "Could not find event."
      redirect_to events_path and return
    end
  end

  def show_verified
    @user = User.find_by_uid(params[:uid])
    if @user.nil?
      flash[:notice] = "Could not find user."
      redirect_to events_path and return
    end
  end

  def confirm
    event = Event.find_by_id(params[:event_id])
    user = User.find_by_id(params[:id])
    if event && user && user.event_id == event.id
      if user.uid.blank?
        user.set_uid
        user.save!
        redirect_to verified_user_path(user.uid) and return
      else
        redirect_to user.event, notice: "User #{user.name} has already claimed their secret page!" and return
      end
    end
    redirect_to events_path, error: "Could not confirm user." and return
  end

  def reset_user
    event = Event.find_by_admin_uid(params[:admin_uid])
    user = User.find_by_uid(params[:uid])
    if event && user && user.event_id == event.id
      user.update_attributes!(:uid => nil)
      redirect_to event_admin_path(event.admin_uid)
    end
  end

end