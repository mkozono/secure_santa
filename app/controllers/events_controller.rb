class EventsController < ApplicationController

  def index
    @events = Event.order("created_at DESC")

    respond_to do |format|
      format.html
      format.json { render :json => @events }
    end
  end

  def show
    @event = Event.find_by_id(params[:id])
    if @event.nil?
      redirect_to events_path, notice: "Could not find event." and return
    else
      if @event.admin_uid.blank?
        promote_to_event_admin
      else
        render :show
      end
    end
  end

  def show_admin
    @event = Event.find_by_admin_uid(params[:admin_uid])
    if @event.nil?
      redirect_to events_path, notice: "Could not find event." and return
    else
      render :show
    end
  end

  def new
  	@event = Event.new

    6.times { @event.players.build } # blank starting fields

    respond_to do |format|
      format.html
      format.json { render :json => @event }
    end
  end

  def create
    begin
      @event = Event.new(create_params)
    rescue ActionController::ParameterMissing => e
      Rails.logger.info "Parameter missing during event create. #{params}"
      return head(:bad_request)
    end

    if @event && @event.save
      flash[:error] = "Successfully created event.  Bookmark this page if you want to be able to edit it later!"
      redirect_to event_admin_path(@event.admin_uid)
    else
      flash[:error] = "Unable to create event."
      render :new
    end
  end

  def edit
    @event = Event.find_by_admin_uid(params[:admin_uid])
    if @event.nil?
      redirect_to events_path, error: "Could not find event." and return
    end
  end

  def update
    success = true
    @event = Event.find_by_admin_uid(params[:admin_uid])
    players_attributes = update_players_params["players_attributes"]
    if players_attributes
      players_attributes = mark_blank_name_deleted players_attributes
      success = @event.destroy_players!(players_attributes)
      success = @event.create_or_update_players(players_attributes) if success
    end
    success = @event.update_attributes(update_event_params) if success
    if success
      redirect_to event_admin_path(@event.admin_uid), notice: "Successfully updated event."
    else
      flash[:error] = "Unable to save edits."
      render :edit
    end
  end

  def destroy
    @event = Event.find_by_admin_uid(params[:admin_uid])
    if @event
      @event.destroy
      flash[:notice] = "Successfully deleted event."
    else
      flash[:error] = "Could not find event."
    end
    redirect_to events_path
  end

  def assign_giftees
    @event = Event.find_by_admin_uid(params[:admin_uid])
    begin
      @event.assign_giftees
      redirect_to event_admin_path(@event.admin_uid), notice: "Successfully assigned giftees!"
    rescue Exception => e
      Rails.logger.error e.inspect
      Rails.logger.error e.backtrace
      redirect_to event_admin_path(@event.admin_uid), notice: "There was an error while assigning giftees."
    end
  end

  private

    def create_params
      params.require(:event).permit(:name, :date, players_attributes: [:name, :id, :_destroy])
    end

    def update_event_params
      params.require(:event).permit(:name, :date)
    end

    def update_players_params
      params.require(:event).permit(players_attributes: [:name, :id, :_destroy])
    end

    def promote_to_event_admin
      @event.set_admin_uid
      @event.save!
      flash[:error] = "You are now the event administrator.  Bookmark this page since there is no other way to edit the event later."
      redirect_to event_admin_path(@event.admin_uid) and return
    end

    def mark_blank_name_deleted players_attributes
      players_attributes.each do |k, player_params|
        if player_params["name"].blank?
          player_params["_destroy"] = "true"
        end
      end
      players_attributes
    end

end
