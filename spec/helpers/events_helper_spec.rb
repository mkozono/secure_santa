require 'spec_helper'

describe EventsHelper do
  describe "#user_role" do
    subject { helper.user_role }
    context "when debug param exists" do
      before do
        helper.stub(:params).and_return({:debug => "1"}.with_indifferent_access)
      end
      context "when environment is development" do
        before do
          Rails.env.stub(:production?).and_return(false)
        end
        it { should eq User::ROLE_SITE_ADMIN }
      end
      context "when environment is production" do
        before do
          Rails.env.stub(:production?).and_return(true)
        end
        it { should_not eq User::ROLE_SITE_ADMIN }
      end
    end
    context "when admin_uid param exists" do
      before do
        event = FactoryGirl.create(:event)
        helper.stub(:params).and_return({:admin_uid => event.admin_uid}.with_indifferent_access)
      end
      it { should eq User::ROLE_EVENT_ADMIN }
    end
    context "when user is not any other role" do
      it { should eq User::ROLE_ANONYMOUS }
    end
  end
end