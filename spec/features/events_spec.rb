require 'spec_helper'

feature "Viewing all events", :js => true do
  # let(:events) { [FactoryGirl.create(:event_with_users), FactoryGirl.create(:event_with_users)] }
  background do
    @events = [Event.create!(:name => "Foo"), Event.create!(:name => "Bar")]
    visit "/events"
  end

  scenario "Events are displayed" do
    @events.each do |event|
      page.body.should match event.name
    end
  end
end

feature "Viewing an event", :js => true do
  let(:event) { FactoryGirl.create(:event_with_users) }
  background do
    visit "/events/#{event.id}"
  end

  scenario "Event information is displayed" do
    page.should have_content(event.name)
    event.users.each do |user|
      page.should have_content(user.name)
    end
  end

  scenario "redirects to index when id not found"
end

feature "Creating a new event", :js => true do
  background do
    visit "/events/new"
  end

  scenario "Adding invitee textboxes" do
    click_link "Add Invitee"
    page.should have_css("input[type='text']", :count => 7)
  end

  scenario "Submitting valid data" do
    fill_in "Event Name", :with => Faker::Company.catch_phrase
    2.times do |index|
      within all(".fields")[index] do
        fill_in "Invitee", :with => Faker::Name.name
      end
    end
    click_on "Create Event"
    page.body.should match "Success" # Hack: The form doesn't seem to be submitted until we access page
    Event.count.should == 1
    User.count.should == 2
  end

  scenario "submitting invalid data"
end

feature "Editing an event", :js => true do
  let(:event) { FactoryGirl.create(:event_with_users) }
  background do
    visit "/events/#{event.id}/edit"
  end

  scenario "Existing event information is displayed" do
    page.body.should match event.name
    event.users.each do |user|
      page.body.should match user.name
    end
  end

  scenario "Submitting valid data" do
    fill_in "Event Name", :with => "New Event Name"
    within all(".fields")[0] do
      fill_in "Invitee", :with => "New User Name"
    end
    click_on "Update Event"
    page.body.should match "Success" # Hack: The form doesn't seem to be submitted until we access page
    event.reload
    event.name.should == "New Event Name"
    event.users.map{|u|u.name}.should include "New User Name"
  end

  scenario "submitting invalid data"
end