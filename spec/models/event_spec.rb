require 'spec_helper'

describe Event do

  describe "validations" do
    it "has a valid factory" do
      FactoryGirl.create(:event).should be_valid
    end

    it "is invalid without a name" do
      FactoryGirl.build(:event, name: nil).should_not be_valid
    end

    it "is invalid with a name over 300 characters" do
      FactoryGirl.build(:event, name: "!"*301).should_not be_valid
    end

    it "validates unique player names" do
      event = Event.new(:name => "An Event")
      2.times { event.players.build(:name => "Foo") }
      event.save.should be_false
    end
  end

  describe "#destroy" do
    it "destroys associated players" do
      event = FactoryGirl.create(:event_with_players, players_count: 3)
      event.reload
      player_count = Player.count
      event.destroy
      Player.count.should == player_count - 3
    end
  end

  describe "#assign_giftees" do
    let(:event) { FactoryGirl.create(:event_with_players, players_count: 3) }
    it "assigns giftees to players" do
      event.reload
      event.assign_giftees
      event.reload
      event.players.each do |player|
        player.giftee.should be_a Player
      end
    end
  end

  describe "#assigned?" do
    let(:event) { FactoryGirl.create(:event_with_players, players_count: 3) }
    context "when all players have a giftee" do
      before do
        assignment_order = { 0 => 2, 1 => 0, 2 => 1 }
        players = event.players.to_a
        players.each_with_index do |player, index|
          player.giftee = players[assignment_order[index]]
          player.save
        end
      end
      it "returns true" do
        event.should be_assigned
      end
    end
    context "when a player does not have a giftee" do
      it "returns false" do
        event.reload
        event.should_not be_assigned
      end
    end
  end

  describe "#unique_admin_uid" do
    let(:event) { FactoryGirl.build(:event) }
    it "returns a random number within the max_uid" do
      expect(event.unique_admin_uid(10000000)).to match /\A\d{7}\z/
    end
    context "when all ids are taken except one" do
      before do
        Event.stub("pluck").with(:admin_uid).and_return(["0","1","2","3","4","5","6","7","8"])
      end
      it "returns the remaining id" do
        expect(event.unique_admin_uid(10)).to eq("9")
      end
    end
  end

  describe "#create" do
    it "calls set_admin_uid" do
      event = FactoryGirl.build(:event)
      event.should_receive(:set_admin_uid)
      event.save
    end
  end

end
