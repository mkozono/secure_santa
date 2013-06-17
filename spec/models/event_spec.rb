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

  context "#destroy" do
    it "destroys associated users" do
      event = FactoryGirl.create(:event_with_users, users_count: 3)
      user_count = User.count
      event.destroy
      User.count.should == user_count - 3
    end
  end

  context "#assign_giftees" do
    context "with users" do
      let(:event) { FactoryGirl.create(:event_with_users, users_count: 3) }
      it "assigns giftees to users" do
        event.assign_giftees
        event.users.each do |user|
          user.giftee.should be_a User
        end
      end
    end
  end

end
