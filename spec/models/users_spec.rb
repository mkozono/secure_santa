require 'spec_helper'

describe Users do
  
  describe "accessible attributes" do
    it "has a name" do
      user = Users.new
      user.name = "Michael"
      user.name.should == "Michael"
    end
  end

  describe "validation" do
    it "requires a name" do
      user = Users.new name: ""
      user.should_not be_valid
    end

  	it "limits name length to 300" do
      user = Users.new name: "a"*301
      user.should_not be_valid
    end
  end

end
