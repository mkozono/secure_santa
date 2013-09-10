class EventsController < ApplicationController

  def index
    @events = Event.all
   
    respond_to do |format|
      format.html
      format.json { render :json => @events }
    end
  end

  def show
    @event = Event.find_by_id(params[:id])
    if @event.nil?
      flash[:notice] = "Could not find event with that ID."
      redirect_to events_path
    end
  end

  def new
  	@event = Event.new

    6.times { @event.users.build } # blank starting fields
 
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
      flash[:notice] = "Successfully created event."
      redirect_to @event
    else
      flash[:error] = "Unable to create event."
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_users(update_users_params) && @event.update_attributes(update_event_params)
      redirect_to @event, notice: "Successfully updated event."
    else
      flash[:error] = "Unable to save edits."
      render :edit
    end
  end

  def destroy
    @event = Event.find_by_id(params[:id])
    if @event
      @event.destroy
      flash[:notice] = "Successfully deleted event."
    else
      flash[:error] = "Could not find event."
    end
    redirect_to events_path
  end

  def assign_giftees
    @event = Event.find(params[:id])
    begin
      @event.assign_giftees
      redirect_to @event
    rescue Exception => e
      Rails.logger.error e.inspect
      Rails.logger.error e.backtrace
      redirect_to @event, notice: "There was an error while assigning giftees."
    end
  end

  private

    def create_params
      params.require(:event).permit(:name, users_attributes: [:name, :id, :_destroy])
    end

    def update_event_params
      params.require(:event).permit(:name)
    end

    def update_users_params
      params.require(:event).permit(users_attributes: [:name, :id, :_destroy])
    end

end
