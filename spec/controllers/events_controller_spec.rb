require 'spec_helper'

describe EventsController do

  describe "GET #index" do
    it "populates an array of events" do
      event = FactoryGirl.create(:event)
      get :index
      assigns(:events).should eq([event])
    end
    it "renders the :index view" do
      get :index
      response.should render_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested event to @event" do
      event = FactoryGirl.create(:event)
      get :show, id: event
      assigns(:event).should eq(event)
    end
    it "renders the :show template" do
      get :show, id: FactoryGirl.create(:event)
      response.should render_template :show
    end
  end

  describe "GET #show_admin" do
    it "assigns the requested event to @event" do
      event = FactoryGirl.create(:event)
      get :show_admin, admin_uid: event.admin_uid
      assigns(:event).should eq(event)
    end
    it "renders the :show template" do
      get :show_admin, admin_uid: FactoryGirl.create(:event).admin_uid
      response.should render_template :show
    end
  end

  describe "GET #new" do
    before do
      get :new
    end
    it "assigns a new event to @event" do
      assigns(:event).name.should be_blank
    end
    it "renders the :new template" do
      response.should render_template :new
    end
    it "assigns at least one blank player to the new event" do
      assigns(:event).players.size.should > 1
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new event in the database" do
        expect {
          post :create, event: FactoryGirl.attributes_for(:event)
        }.to change(Event, :count).by(1)
      end
      it "redirects to the show_admin action" do
        post :create, event: FactoryGirl.attributes_for(:event)
        response.should redirect_to event_admin_path(Event.last.admin_uid)
      end
    end
    context "with invalid attributes" do
      it "does not save the event in the database" do
        expect {
          post :create, event: FactoryGirl.attributes_for(:event, :invalid)
        }.to_not change(Event, :count)
      end
      it "re-renders the :new template" do
        post :create, event: FactoryGirl.attributes_for(:event, :invalid)
        response.should render_template :new
      end
    end
    context "missing a required attribute" do
      before do
        post :create, event: nil
      end
      it "returns 400 bad request" do
        response.response_code.should == 400
      end
    end
    context "with an unknown attribute" do
      before do
        post :create, event: FactoryGirl.attributes_for(:event), bad_attribute: "malicious data"
      end
      it "ignores the extra attribute" do
        response.should redirect_to action: :show_admin, admin_uid: assigns(:event).admin_uid
      end
    end
  end

  describe "GET #edit" do
    before do
      @event = FactoryGirl.create(:event)
      get :edit, admin_uid: @event.admin_uid
    end
    it "assigns the requested event to @event" do
      assigns(:event).should eq(@event)
    end
    it "renders the :edit template" do
      response.should render_template :edit
    end
  end

  describe 'PUT #update' do
    before do
      @event = FactoryGirl.create(:event, name: "My Event")
    end

    context "valid attributes" do
      it "located the requested @event" do
        put :update, admin_uid: @event.admin_uid, event: FactoryGirl.attributes_for(:event)
        assigns(:event).should eq(@event)
      end

      it "changes @event's attributes" do
        put :update, admin_uid: @event.admin_uid, event: FactoryGirl.attributes_for(:event, name: "Different Event Name")
        @event.reload
        @event.name.should eq("Different Event Name")
      end

      it "redirects to the updated event" do
        put :update, admin_uid: @event.admin_uid, event: FactoryGirl.attributes_for(:event)
        response.should redirect_to event_admin_path(@event.admin_uid)
      end
      context "with nested players attributes" do
        it "updates players" do
          FactoryGirl.create(:player, event: @event, name: "An Old Name")
          @event.reload
          put :update, admin_uid: @event.admin_uid, event: { players_attributes: {"0" => {"id" => @event.players.first.id, "name" => "A New Name"}} }
          @event.reload
          @event.players.first.name.should eq("A New Name")
        end
        it "creates players" do
          put :update, admin_uid: @event.admin_uid, event: { players_attributes: {"0" => {"id" => "123456789", "name" => "Some Name"}} }
          @event.reload
          @event.players.size.should == 1
        end
        it "destroys players" do
          FactoryGirl.create(:player, event: @event, name: "To Be Destroyed")
          @event.reload
          put :update, admin_uid: @event.admin_uid, event: { players_attributes: {"0" => {"id" => @event.players.first.id, "_destroy" => "true"}} }
          @event.reload
          @event.players.size.should == 0
        end
      end
    end

    context "invalid attributes" do
      it "locates the requested @event" do
        put :update, admin_uid: @event.admin_uid, event: FactoryGirl.attributes_for(:event, :invalid)
        assigns(:event).should eq(@event)
      end

      it "does not change @event's attributes" do
        put :update, admin_uid: @event.admin_uid, event: FactoryGirl.attributes_for(:event, name: nil)
        @event.reload
        @event.name.should_not eq(nil)
      end

      it "re-renders the edit method" do
        put :update, admin_uid: @event.admin_uid, event: FactoryGirl.attributes_for(:event, :invalid)
        response.should render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    context "when the event exists" do
      before :each do
        @event = FactoryGirl.create(:event)
      end

      it "deletes the event" do
        expect{
          delete :destroy, admin_uid: @event.admin_uid
        }.to change(Event,:count).by(-1)
      end

      it "redirects to events#index" do
        delete :destroy, admin_uid: @event.admin_uid
        response.should redirect_to events_url
      end
    end
    context "when the event does not exist" do
      it "redirects to events#index" do
        delete :destroy, admin_uid: 9999999999
        response.should redirect_to events_url
      end
    end
  end

  describe 'PUT #assign_giftees' do
    context "when the event is ready for assignment" do
      let(:event) { FactoryGirl.create(:event_with_players, players_count: 3) }
      it "assigns giftees" do
        put :assign_giftees, admin_uid: event.admin_uid
        event.players.each do |player|
          player.giftee.should be_present
        end
      end
      it "redirects to show the event" do
        put :assign_giftees, admin_uid: event.admin_uid
        response.should redirect_to event_admin_path(event.admin_uid)
      end
    end
    context "when the event is not ready for assignment" do
      let(:event) { FactoryGirl.create(:event_with_players, players_count: 2) }
      it "does not assign giftees" do
        put :assign_giftees, admin_uid: event.admin_uid
        event.players.each do |player|
          player.giftee.should be_nil
        end
      end
      it "redirects to show the event" do
        put :assign_giftees, admin_uid: event.admin_uid
        response.should redirect_to event_admin_path(event.admin_uid)
      end
    end
  end

end
