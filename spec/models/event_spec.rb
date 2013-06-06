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
      event = FactoryGirl.create(:event_with_users)
      user_count = User.count
      event.destroy
      User.count.should == user_count - 5
    end
  end

end
