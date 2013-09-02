require 'spec_helper'

describe User do

  it "has a valid factory" do
    FactoryGirl.create(:user).should be_valid
  end

  it "is invalid without a name" do
    FactoryGirl.build(:user, name: nil).should_not be_valid
  end

  it "is invalid with a name over 400 characters" do
    FactoryGirl.build(:user, name: "!"*401).should_not be_valid
  end

  it "is invalid without an event" do
    FactoryGirl.build(:user, event: nil).should_not be_valid
  end

  describe "giftee" do
    before do
      @christmas = FactoryGirl.create(:event)
      @bob = FactoryGirl.create(:user, event: @christmas)
      @sue = FactoryGirl.create(:user, event: @christmas)
    end

    it "can have a giftee" do
      @bob.giftee = @sue
      @bob.giftee.should == @sue
      @sue.gifter.should == @bob
    end

    context "when assigning a giftee belonging to the same event" do
      it "is valid" do
        @bob.giftee = @sue
        @bob.should be_valid
      end
    end
    context "when assigning a giftee belonging to a different event" do
      it "is invalid" do
        thanksgiving = FactoryGirl.create(:event)
        @sue.event = thanksgiving
        @bob.giftee = @sue
        @bob.should_not be_valid
      end
    end
  end

  specify "name must be unique per event" do
    event = FactoryGirl.create(:event)
    FactoryGirl.create(:user, name: "Bob", event: event)
    FactoryGirl.build(:user, name: "Bob", event: event).should_not be_valid
  end

end
