require 'spec_helper'

describe "Events" do

  describe "GET #index" do
    context "when events exist" do
      before do
        FactoryGirl.create(:event, :name => "Christmas Get Together 2014")
        FactoryGirl.create(:event, :name => "Yay Party Time")
      end
      it "returns a list of events" do
        get events_path
        response.body.should match /Yay Party Time/
        response.body.should match /Christmas Get Together 2014/
      end
    end
    context "when no events exist" do
      pending "it says 'No events found.'"
    end
  end

  describe "GET #show" do
    context "with a valid event id" do
      before do
        @event = FactoryGirl.create(:event, name: "Yay Party Time")
        FactoryGirl.create(:user, name: "Broseph", event: @event)
        get event_path(@event.id)
      end
      specify { response.body.should match /Yay Party Time/ }
      specify { response.body.should match /Broseph/ }
    end
    context "with an invalid event id" do
      pending "it displays 'Event not found.'"
    end
  end

  describe "GET #new" do
    before do
      get new_event_path
    end
    it "has a least one text field" do
      response.body.should match /<input[^>]+type="text"/
    end
    it "has a submit button" do
      response.body.should match /<input[^>]+type="submit"/
    end
  end

  describe "POST #create" do
    before do
      user_params = FactoryGirl.attributes_for(:user)
      @event_params = FactoryGirl.attributes_for(:event)
      @event_params[:users_attributes] = { "0" => user_params }
    end
    context "with valid parameters" do
      before do
        post events_path, event: @event_params
      end
      it "redirects to show action" do
        response.should redirect_to action: :show,
                                   id: assigns(:event).id
      end
    end
    context "with invalid parameters" do
      context "that will not pass model validations" do
        before do
          @event_params[:name] = "A" * 500
          post events_path, event: @event_params
        end
        it "displays the error messages" do
          response.body.should match /Name is too long/
        end
      end
    end
  end

  describe "GET #edit" do
    before do
      @event = FactoryGirl.create :event
      @user = FactoryGirl.create :user, event: @event
      get edit_event_path(@event.id)
    end
    it "has a least one text field" do
      response.body.should match /<input[^>]+type="text"/
    end
    it "has a submit button" do
      response.body.should match /<input[^>]+type="submit"/
    end
    it "displays the event name" do
      response.body.should match @event.name
    end
    it "displays the user name" do
      response.body.should match @user.name
    end
  end

  describe "PUT #update" do
    before do
      @event = FactoryGirl.create :event
    end
    context "when submitting a new event name" do
      before do
        put event_path id: @event, event: FactoryGirl.attributes_for(:event, name: "Different Event Name")
      end
      it "saves the event name" do
        @event.reload
        @event.name.should == "Different Event Name"
      end
    end
  end

end