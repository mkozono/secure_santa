require 'spec_helper'

describe User do

  describe "validations" do
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

    specify "name must be unique per event" do
      event = FactoryGirl.create(:event)
      FactoryGirl.create(:user, name: "Bob", event: event)
      FactoryGirl.build(:user, name: "Bob", event: event).should_not be_valid
    end
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

  describe "#unique_admin_uid" do
    let(:user) { FactoryGirl.build(:user) }
    it "returns a random number within the max_uid" do
      expect(user.unique_uid(10000000)).to match /\A\d{7}\z/
    end
    context "when all ids are taken except one" do
      before do
        User.stub("pluck").with(:uid).and_return(["0","1","2","3","4","5","6","7","8"])
      end
      it "returns the remaining id" do
        expect(user.unique_uid(10)).to eq("9")
      end
    end
  end

  describe "attributes" do
    describe "message" do
      let(:user) { FactoryGirl.build(:user) }
      it "can handle long values" do
        user.update_attributes(:message => "10 chars. " * 1000).should be_true
      end
    end
  end

end
