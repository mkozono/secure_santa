require 'spec_helper'

describe Users do
  
  describe "accessible attributes" do
    it "has a name" do
      u = Users.new
      u.name = "Michael"
      u.name.should == "Michael"
    end
  end

end
