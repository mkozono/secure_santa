require 'spec_helper'

describe Event do
  
  it "has a valid factory" do
    FactoryGirl.create(:event).should be_valid
  end

  it "is invalid without a name" do
    FactoryGirl.build(:event, name: nil).should_not be_valid
  end

  it "is invalid with a name over 300 characters" do
    FactoryGirl.build(:event, name: "!"*301).should_not be_valid
  end

  describe "#destroy" do
    it "destroys associated users" do
      event = FactoryGirl.create(:event_with_users, users_count: 3)
      user_count = User.count
      event.destroy
      User.count.should == user_count - 3
    end
  end

  describe "#assign_giftees" do
    let(:event) { FactoryGirl.create(:event_with_users, users_count: 3) }
    it "assigns giftees to users" do
      event.assign_giftees
      event.users.each do |user|
        user.giftee.should be_a User
      end
    end
  end

  describe "#assigned?" do
    let(:event) { FactoryGirl.create(:event_with_users, users_count: 3) }
    context "when all users have a giftee" do
      before do
        assignment_order = { 0 => 2, 1 => 0, 2 => 1 }
        users = event.users.to_a
        users.each_with_index do |user, index|
          user.giftee = users[assignment_order[index]]
          user.save
        end
      end
      it "returns true" do
        event.should be_assigned
      end
    end
    context "when a user does not have a giftee" do
      it "returns false" do
        event.should_not be_assigned
      end
    end

  end

end
