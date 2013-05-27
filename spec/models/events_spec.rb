require 'spec_helper'

describe Event do
  
  describe "accessible attributes" do
    it "has a name" do
      event = Event.new
      event.name = "Christmas 2013"
      event.name.should == "Christmas 2013"
    end
  end

  describe "validation" do
    it "requires a name" do
      event = Event.new name: ""
      event.should_not be_valid
    end

  	it "limits name length to 300" do
      event = Event.new name: "a"*301
      event.should_not be_valid
    end
  end

end
