require 'spec_helper'

describe OmniauthCallbacksController do
  describe "#facebook" do
    subject { get :facebook }
    let(:user) { FactoryGirl.create :user }
    before do
      auth_hash = { provider: :facebook, uid: 123, info: {name: "Alexandre Dumas", image: "http://my/selfie/url/here"} }
      @request.env["omniauth.auth"] = Hashie::Mash.new(auth_hash)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      User.stub(:from_omniauth => user)
    end
    it "finds or creates the user by provider and uid" do
      User.should_receive(:from_omniauth).and_return(user)
      subject
    end
    context "when the user is persisted" do
      it "flashes successful sign in" do
        subject
        expect(flash[:notice]).to eq "Signed in successfully!"
      end
      context "when the sign in request had an origin" do
        before { @request.env["omniauth.origin"] = "http://my/origin" }
        it "redirects to origin" do
          expect(subject).to redirect_to "http://my/origin"
        end
      end
      context "when the sign in request did NOT have an origin" do
        it "redirects to the user" do
          expect(subject).to redirect_to user
        end
      end
    end
    context "when the user is NOT persisted" do
      before { user.stub(:persisted? => false) }
      it "redirects to root" do
        expect(subject).to redirect_to root_path
      end
      it "flashes and error" do
        subject
        expect(flash[:error]).to eq "Error while signing in."
      end
    end
  end
end
