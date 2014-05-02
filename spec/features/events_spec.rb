require 'spec_helper'

feature "Viewing all events", :js => true do
  background do
    @events = [Event.create!(:name => "Foo"), Event.create!(:name => "Bar")]
    visit events_path
  end

  scenario "Events are displayed" do
    @events.each do |event|
      page.body.should match event.name
    end
  end
end

feature "Viewing an event", :js => true do
  let(:event) { FactoryGirl.create(:event_with_players) }

  scenario "Event information is displayed" do
    visit event_path(event)
    page.should have_content(event.name)
    event.players.each do |player|
      page.should have_content(player.name)
    end
  end

  scenario "redirects to index when id not found" do
    visit "/events/99999999"
    page.should have_content "Could not find"
    current_path.should == events_path
  end
end

feature "Creating a new event", :js => true do
  background do
    visit new_event_path
  end

  scenario "Adding invitee textboxes" do
    click_link "Add Invitee"
    page.should have_css("input[type='text']", :count => 8)
  end

  scenario "Submitting valid data" do
    fill_in "Event Name", :with => Faker::Company.catch_phrase
    find(:css, "input[id='event_players_attributes_0_name']").set(Faker::Name.name)
    find(:css, "input[id='event_players_attributes_1_name']").set(Faker::Name.name)
    click_on "Create Event"
    page.body.should match "Success" # Hack: The form doesn't seem to be submitted until we access page
    Event.count.should == 1
    Player.count.should == 2
  end

  scenario "submitting invalid data" do
    expect {
      click_on "Create Event"
      page.body.should match "Unable to create"
    }.to_not change(Event, :count)
  end
end

feature "Editing an event", :js => true do
  let(:event) { FactoryGirl.create(:event_with_players) }
  background do
    visit edit_event_path(event.admin_uid)
  end

  scenario "Existing event information is displayed" do
    page.body.should match event.name
    event.players.each do |player|
      page.body.should match player.name
    end
  end

  scenario "Submitting valid data" do
    fill_in "Event Name", :with => "New Event Name"
    find(:css, "input[id='event_players_attributes_0_name']").set("New Player Name")
    click_on "Update Event"
    page.body.should match "Success" # Hack: The form doesn't seem to be submitted until we access page
    event.reload
    event.name.should == "New Event Name"
    event.players.map{|u|u.name}.should include "New Player Name"
  end

  scenario "submitting invalid data" do
    fill_in "Event Name", with: ""
    expect {
      click_on "Update Event"
      page.body.should match "Unable to save"
    }.to_not change(Event, :count)
  end
end

feature "Deleting an event", :js => true do
  let(:event) { FactoryGirl.create(:event_with_players) }
  background do
    visit event_admin_path(event.admin_uid)
  end

  scenario "Clicking delete button" do
    expect {
      click_on "Delete Event"
      page.body.should match "Success" # Hack: The form doesn't seem to be submitted until we access page
    }.to change(Event, :count).from(1).to(0)
  end
end
