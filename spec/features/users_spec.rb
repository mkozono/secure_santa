require 'spec_helper'

feature "Viewing a verified user", :js => true do
  let!(:user) { FactoryGirl.create(:user, uid: "secretuid") }
  scenario "Name is displayed" do
    visit verified_user_path("secretuid")
    page.should have_content(user.name)
  end

  context "when the user has a giftee" do
    context "when the giftee has a message" do
      let!(:giftee) { FactoryGirl.create(:user, event: user.event, uid: "gifteesecret", message: "This is my wishlist.") }
      before do
        user.giftee = giftee
        user.save!
      end
      scenario "message is displayed" do
        visit verified_user_path("secretuid")
        page.body.should match(giftee.message)
      end
      scenario "message is disabled" do
        visit verified_user_path("secretuid")
        page.should have_css("textarea[name='giftee_message'][disabled]")
      end
    end
  end
end