class EventsController < ApplicationController

  def index
    @events = Event.all
   
    respond_to do |format|
      format.html
      format.json { render :json => @events }
    end
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
    @event = Event.new(params[:event])
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
    
    if @event.update_attributes(params[:event])
      flash[:notice] = "Successfully updated event."
      redirect_to @event
    else
      flash[:error] = "Unable to save edits."
      render :edit
    end
  end

  def show
    @event = Event.find(params[:id])
  end
end
