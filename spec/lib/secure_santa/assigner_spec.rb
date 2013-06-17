require 'secure_santa/assigner'

module SecureSanta

  describe Assigner do

    describe ".new" do
      context "with valid arguments" do
        let(:user_ids) { [1, 2, 3] }
        it "does not raise exception" do
          expect { Assigner.new user_ids }.to_not raise_error
        end
      end
      context "with invalid arguments" do
        context "when user_ids is not an Enumerable" do
          let(:user_ids) { "Not an Enumerable" }
          it "raises ArgumentError" do
            expect { Assigner.new user_ids }.to raise_error(ArgumentError)
          end
        end
        context "when user_ids is empty" do
          let(:user_ids) { [] }
          it "raises ArgumentError" do
            expect { Assigner.new user_ids }.to raise_error(ArgumentError)
          end
        end
        context "when user_ids are not unique" do
          let(:user_ids) { [1, 2, 2] }
          it "raises ArgumentError" do
            expect { Assigner.new user_ids }.to raise_error(ArgumentError)
          end
        end
        context "when there are less than 3 user_ids" do
          let(:user_ids) { [1, 2] }
          it "raises ArgumentError" do
            expect { Assigner.new user_ids }.to raise_error(ArgumentError)
          end
        end
      end
    end

    describe "#assign_giftees" do
      let(:assigner) { Assigner.new([1, 2, 3]) }
      it "returns a Hash" do
        assigner.assign_giftees.should be_a Hash
      end
      it "does not assign IDs to themselves" do
        30.times do
          assignments = assigner.assign_giftees
          assignments.keys.each do |key|
            assignments[key].should_not == key
          end
        end
      end
      specify "the set of keys must match the user_ids" do
        assigner.assign_giftees.keys.should =~ [1, 2, 3]
      end
      specify "the set of values must match the user_ids" do
        assigner.assign_giftees.values.should =~ [1, 2, 3]
      end
    end

  end

end