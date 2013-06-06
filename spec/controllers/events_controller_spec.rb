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
    it "assigns at least one blank user to the new event" do
      assigns(:event).users.size.should > 1
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new event in the database" do
        expect {
          post :create, event: FactoryGirl.attributes_for(:event)
        }.to change(Event, :count).by(1)
      end
      it "redirects to the show action" do
        post :create, event: FactoryGirl.attributes_for(:event)
        response.should redirect_to Event.last
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
        response.should redirect_to action: :show,
                                   id: assigns(:event).id
      end
    end
  end

  describe "GET #edit" do
    before do
      @event = FactoryGirl.create(:event)
      get :edit, id: @event
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
        put :update, id: @event, event: FactoryGirl.attributes_for(:event)
        assigns(:event).should eq(@event)      
      end
    
      it "changes @event's attributes" do
        put :update, id: @event, event: FactoryGirl.attributes_for(:event, name: "Different Event Name")
        @event.reload
        @event.name.should eq("Different Event Name")
      end
    
      it "redirects to the updated event" do
        put :update, id: @event, event: FactoryGirl.attributes_for(:event)
        response.should redirect_to @event
      end
    end
    
    context "invalid attributes" do
      it "locates the requested @event" do
        put :update, id: @event, event: FactoryGirl.attributes_for(:event, :invalid)
        assigns(:event).should eq(@event)      
      end
      
      it "does not change @event's attributes" do
        put :update, id: @event, event: FactoryGirl.attributes_for(:event, name: nil)
        @event.reload
        @event.name.should_not eq(nil)
      end
      
      it "re-renders the edit method" do
        put :update, id: @event, event: FactoryGirl.attributes_for(:event, :invalid)
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
          delete :destroy, id: @event        
        }.to change(Event,:count).by(-1)
      end
        
      it "redirects to events#index" do
        delete :destroy, id: @event
        response.should redirect_to events_url
      end
    end
    context "when the event does not exist" do
      it "redirects to events#index" do
        delete :destroy, id: 9999999
        response.should redirect_to events_url
      end
    end
  end

end
