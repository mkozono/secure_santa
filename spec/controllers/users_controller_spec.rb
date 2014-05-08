require 'spec_helper'

describe UsersController do

  describe "GET #events" do
    subject { get :events }
    context "when the user is signed in" do
      let(:user) { FactoryGirl.create :user }
      before do
        FactoryGirl.create :player, user: user
        FactoryGirl.create :player, user: user
        sign_in user
      end
      it "sets @players" do
        subject
        expect(user.players.size).to eq 2
        expect(assigns(:players)).to eq user.players
      end
    end
    context "when the user is NOT signed in" do
      it { should redirect_to events_path }
    end
  end
end