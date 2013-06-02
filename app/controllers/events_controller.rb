class EventsController < ApplicationController

  def index
    @events = Event.all
   
    respond_to do |format|
      format.html
      format.json { render :json => @events }
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
  	@event = Event.new

    5.times { @event.users.build } # blank starting fields
 
    respond_to do |format|
      format.html
      format.json { render :json => @event }
    end
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      flash[:notice] = "Successfully created event."
      redirect_to @event
    else
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(event_params)
      flash[:notice] = "Successfully updated event."
      redirect_to @event
    else
      flash[:error] = "Unable to save edits."
      render :edit
    end
  end

  private

    def event_params
      params.require(:event).permit(:name, users_attributes: [:name, :id, :_destroy])
    end

end
