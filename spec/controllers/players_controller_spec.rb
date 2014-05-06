require 'spec_helper'

describe PlayersController do

  describe "GET #show" do
    let(:player) { FactoryGirl.create(:player) }
    it "assigns the requested player to @player" do
      get :show, event_id: player.event_id, id: player
      assigns(:player).should eq(player)
    end
    it "renders the :show template" do
      get :show, event_id: player.event_id, id: player
      response.should render_template :show
    end
    context "when the player has a uid" do
      it "redirects to the event page" do
        player.set_uid
        player.save!
        get :show, event_id: player.event_id, id: player
        response.should redirect_to player.event
      end
    end
  end

  describe "GET #show_verified" do
    let(:player) { FactoryGirl.create(:player, uid: "0001234") }
    it "assigns the requested player to @player" do
      get :show_verified, uid: player.uid
      assigns(:player).should eq(player)
    end
    it "renders the :show_verified template" do
      get :show_verified, uid: player.uid
      response.should render_template :show_verified
    end
  end

  describe "PATCH #confirm" do
    context "when the player doesn't have a uid" do
      let(:player) { FactoryGirl.create(:player) }
      context "when the user is signed in" do
        before do
          user = User.create!
          sign_in user
          patch :confirm, event_id: player.event_id, id: player.id
          player.reload
        end
        it "sets the uid" do
          player.uid.should be_present
        end
        it "sets the player's user" do
          player.user.should be_present
        end
      end
      context "when the user is NOT signed in" do
        before do
          patch :confirm, event_id: player.event_id, id: player.id
          player.reload
        end
        it "sets the uid" do
          player.uid.should be_present
        end
        it "does NOT set the player's user" do
          player.user.should be_nil
        end
      end
    end
    context "when the player is claimed" do
      let(:player) { FactoryGirl.create(:player, uid: "1234567") }
      context "when the user is signed in" do
        it "redirects to the event" do
          patch :confirm, event_id: player.event_id, id: player.id
          response.should redirect_to player.event
        end
      end
      context "when the user is NOT signed in" do
        it "redirects to the event" do
          patch :confirm, event_id: player.event_id, id: player.id
          response.should redirect_to player.event
        end
      end
    end
    context "when the params are invalid" do
      it "raises error" do
        expect{patch :confirm, event_id: nil, id: player.id}.
          to raise_error
        expect{patch :confirm, event_id: player.event_id, id: nil}.
          to raise_error
      end
    end
  end

  describe "PATCH #reset_player" do
    it "clears the uid" do
      player = FactoryGirl.create(:player, uid: "1234567")
      patch :reset_player, admin_uid: player.event.admin_uid, uid: "1234567"
      player.reload
      player.uid.should be_blank
    end
  end

  describe "PATCH #update_verified" do
    it "updates the message" do
      player = FactoryGirl.create(:player, uid: "1234567")
      patch :update_verified, uid: "1234567", player: { message: "Player's message to their Secret Santa" }
      player.reload
      player.message.should be_present
    end
    it "redirects to verified_player show page" do
      player = FactoryGirl.create(:player, uid: "1234567")
      patch :update_verified, uid: "1234567", player: { message: "Player's message to their Secret Santa" }
      response.should redirect_to verified_player_path("1234567")
    end
  end

end
