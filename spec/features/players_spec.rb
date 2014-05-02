require 'spec_helper'

feature "Viewing a verified player", :js => true do
  let!(:player) { FactoryGirl.create(:player, uid: "secretuid") }
  scenario "Name is displayed" do
    visit verified_player_path("secretuid")
    page.should have_content(player.name)
  end

  context "when the player has a giftee" do
    context "when the giftee has a message" do
      let!(:giftee) { FactoryGirl.create(:player, event: player.event, uid: "gifteesecret", message: "This is my wishlist.") }
      before do
        player.giftee = giftee
        player.save!
      end
      scenario "message is displayed" do
        visit verified_player_path("secretuid")
        page.body.should match(giftee.message)
      end
      scenario "message is disabled" do
        visit verified_player_path("secretuid")
        page.should have_css("textarea[name='giftee_message'][disabled]")
      end
    end
  end
end
