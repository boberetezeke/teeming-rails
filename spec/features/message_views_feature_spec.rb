require 'rails_helper'
include Warden::Test::Helpers
require 'capybara-screenshot/rspec'
require 'support/authentication'


context "when testing with a normal user" do
  let(:chapter) { Chapter.find_by_name("Duluth") }
  let(:other_chapter) { Chapter.find_by_name("Alexandria") }

  before do
    Rails.application.load_seed # loading seeds
    user.update(setup_state: nil)
    sign_in user
  end

  describe "messages index" do
    context "with an ordinary user" do
      let(:user)    { FactoryGirl.create(:user) }

      it "shows empty list if there are no messages" do
        visit chapter_messages_path(chapter)
        expect(page).to have_text "There are no messages for this chapter"
      end

      context "where there are messages for the chapter" do
        let!(:message) { FactoryGirl.create(:message) }

        before do
          chapter.messages << message
          visit chapter_messages_path(chapter)
        end

        it "shows message in list" do
          expect(page).to have_text message.subject
        end

        it "doesn't show edit draft button" do
          expect(page).to_not have_text "Edit Draft"
        end

        it "doesn't show delete button" do
          expect(page).to_not have_text "Delete"
        end
      end
    end

    context "with an messages user" do
      let!(:message) { FactoryGirl.create(:message) }
      let(:user) do
        FactoryGirl.create(:user,
                         role: Role.new(privileges:
                                        [Privilege.new(subject: 'message',
                                                       action: 'send',
                                                       scope: {chapter_id: chapter.id}.to_json)]))
      end

      context "where there are messages for the chapter" do
        before do
          chapter.messages << message
          visit chapter_messages_path(chapter)
        end

        it "shows message in list" do
          expect(page).to have_text message.subject
        end

        it "doesn't show edit draft button" do
          expect(page).to have_text "Edit Draft"
        end

        it "doesn't show delete button" do
          expect(page).to have_text "Delete"
        end
      end

      context "with an messages user for a different chapter" do
        let!(:message) { FactoryGirl.create(:message) }
        let(:user) do
          FactoryGirl.create(:user,
                             role: Role.new(privileges:
                                            [Privilege.new(subject: 'message',
                                               action: 'send',
                                               scope: {chapter_id: other_chapter.id}.to_json)]))
        end

        context "where there are messages for the chapter" do
          before do
            chapter.messages << message
            visit chapter_messages_path(chapter)
          end

          it "shows message in list" do
            expect(page).to have_text message.subject
          end

          it "doesn't show edit draft button" do
            expect(page).to_not have_text "Edit Draft"
          end

          it "doesn't show delete button" do
            expect(page).to_not have_text "Delete"
          end
        end
      end
    end
  end
end

