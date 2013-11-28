class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    if @user.nil?
      flash[:notice] = "Could not find a user with that ID."
      redirect_to events_path
    end
  end

end