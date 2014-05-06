require 'spec_helper'

describe Player do

  describe "validations" do
    it "has a valid factory" do
      FactoryGirl.create(:player).should be_valid
    end

    it "is invalid without a name" do
      FactoryGirl.build(:player, name: nil).should_not be_valid
    end

    it "is invalid with a name over 400 characters" do
      FactoryGirl.build(:player, name: "!"*401).should_not be_valid
    end

    it "is invalid without an event" do
      FactoryGirl.build(:player, event: nil).should_not be_valid
    end

    specify "name must be unique per event" do
      event = FactoryGirl.create(:event)
      FactoryGirl.create(:player, name: "Bob", event: event)
      FactoryGirl.build(:player, name: "Bob", event: event).should_not be_valid
    end
  end

  describe "giftee" do
    before do
      @christmas = FactoryGirl.create(:event)
      @bob = FactoryGirl.create(:player, event: @christmas)
      @sue = FactoryGirl.create(:player, event: @christmas)
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
    let(:player) { FactoryGirl.build(:player) }
    it "returns a random number within the max_uid" do
      expect(player.unique_uid(10000000)).to match /\A\d{7}\z/
    end
    context "when all ids are taken except one" do
      before do
        Player.stub("pluck").with(:uid).and_return(["0","1","2","3","4","5","6","7","8"])
      end
      it "returns the remaining id" do
        expect(player.unique_uid(10)).to eq("9")
      end
    end
  end

  describe "#claimed?" do
    subject { player.claimed? }
    context "when the player has a uid" do
      let(:player) { FactoryGirl.build(:player, :uid => '123') }
      it { should be_true }
    end
    context "when the player has a user" do
      let(:player) { FactoryGirl.build(:player, :user => User.create!) }
      it { should be_true }
    end
    context "when the player has NEITHER a uid or user" do
      let(:player) { FactoryGirl.build(:player) }
      it { should be_false }
    end
  end

  describe "attributes" do
    describe "message" do
      let(:player) { FactoryGirl.build(:player) }
      it "can handle long values" do
        player.update_attributes(:message => "10 chars. " * 1000).should be_true
      end
    end
  end

end
