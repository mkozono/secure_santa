require 'spec_helper'

describe UsersController do

  describe "GET #show" do
    let(:user) { FactoryGirl.create(:user) }
    it "assigns the requested user to @user" do
      get :show, event_id: user.event_id, id: user
      assigns(:user).should eq(user)
    end
    it "renders the :show template" do
      get :show, event_id: user.event_id, id: user
      response.should render_template :show
    end
    context "when the user has a uid" do
      it "redirects to the event page" do
        user.set_uid
        user.save!
        get :show, event_id: user.event_id, id: user
        response.should redirect_to user.event
      end
    end
  end

  describe "GET #show_verified" do
    let(:user) { FactoryGirl.create(:user, uid: "0001234") }
    it "assigns the requested user to @user" do
      get :show_verified, uid: user.uid
      assigns(:user).should eq(user)
    end
    it "renders the :show_verified template" do
      get :show_verified, uid: user.uid
      response.should render_template :show_verified
    end
  end

  describe "PATCH #confirm" do
    context "when the user doesn't have a uid" do
      it "sets the uid" do
        user = FactoryGirl.create(:user)
        patch :confirm, event_id: user.event_id, id: user.id
        user.reload
        user.uid.should be_present
      end
    end
    context "when the user already has a uid" do
      it "redirects to the event" do
        user = FactoryGirl.create(:user, uid: "1234567")
        patch :confirm, event_id: user.event_id, id: user.id
        response.should redirect_to user.event
      end
    end
  end

end