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

end
