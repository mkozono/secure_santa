require 'spec_helper'

describe User do
  describe ".from_omniauth" do
    subject { User.from_omniauth(auth_hash) }
    let(:auth_hash) { Hashie::Mash.new(:provider => 'foo', :uid => 'bar', :info => {:name => 'baz'}) }
    context "when a matching user exists" do
      let!(:user) { User.create!(:provider => 'foo', :uid => 'bar') }
      it "does NOT create a new user" do
        expect{subject}.to_not change{User.count}
      end
      it { should eq user }
    end
    context "when a matching user does NOT exist" do
      it "creates a new user" do
        expect{subject}.to change{User.count}.by(1)
      end
      its(:provider) { should eq 'foo' }
      its(:uid) { should eq 'bar' }
      its(:name) { should eq 'baz' }
    end
  end
end
