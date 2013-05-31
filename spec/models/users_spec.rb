require 'spec_helper'

describe User do
  
  describe "accessible attributes" do
    it "has a name" do
      user = User.new
      user.name = "Michael"
      user.name.should == "Michael"
    end
  end

  describe "validation" do
    it "requires a name" do
      user = User.new name: ""
      user.should_not be_valid
    end

  	it "limits name length to 400" do
      user = User.new name: "a"*401
      user.should_not be_valid
    end
  end

end
