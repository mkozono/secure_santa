require 'spec_helper'

describe PlayersController do

  describe "GET #show" do
    let(:player) { FactoryGirl.create(:player) }
    context "given a bad id" do
      it "redirects to the event" do
        get :show, event_id: player.event_id, id: 999
        response.should redirect_to event_path(player.event_id)
      end
    end
    context "given a signed in user who has claimed this player" do
      let(:user) { FactoryGirl.create(:user) }
      let(:player) { FactoryGirl.create(:player, :user => user, :uid => 123) }
      it "redirects to the verified player page" do
        sign_in user
        get :show, event_id: player.event_id, id: player.id
        response.should redirect_to verified_player_path(123)
      end
    end
    context "given a good id and NO signed in user" do
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
      let(:player) { FactoryGirl.create(:player) }
      let(:player2) { FactoryGirl.create(:player) }
      before { player.event.should_not eq player2.event }
      it "redirects to events#index" do
        expect(patch :confirm, event_id: 999, id: player.id).to redirect_to events_path
        expect(patch :confirm, event_id: player.event_id, id: 999).to redirect_to events_path
        expect(patch :confirm, event_id: player.event_id, id: player2.id).to redirect_to events_path
      end
    end
  end

  describe "PATCH #reset_player" do
    let(:player) { FactoryGirl.create(:player, uid: "1234567") }
    context "given valid params" do
      it "clears the uid" do
        patch :reset_player, admin_uid: player.event.admin_uid, uid: 1234567
        player.reload
        player.uid.should be_blank
      end
    end
    context "given invalid params" do
      context "given existing admin_uid" do
        it "redirects to the event" do
          expect(patch :reset_player, admin_uid: player.event.admin_uid, uid: 999).to redirect_to player.event
        end
      end
      context "given non-existent admin_uid" do
        it "redirects to events" do
          expect(patch :reset_player, admin_uid: 999, uid: player.uid).to redirect_to events_path
        end
      end
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
