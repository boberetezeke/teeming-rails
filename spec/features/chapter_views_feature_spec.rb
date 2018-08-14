require 'rails_helper'
include Warden::Test::Helpers
require 'capybara-screenshot/rspec'
require 'support/authentication'


context "when testing with a normal user" do
  before do
    Rails.application.load_seed # loading seeds
    user.update(setup_state: nil)
    sign_in user
  end

  describe "shows dashboard" do
    let(:user) { FactoryBot.create(:user) }

    before do
      visit home_users_path
    end

    it "displays the main page" do
      expect(page).to have_selector "a[href='/chapters']"
    end
  end

  describe "external elections display" do
    let(:chapter) { Chapter.find_by_name("Duluth") }
    let(:other_chapter) { Chapter.find_by_name("Alexandria") }

    before do
      Election.destroy_all
    end

    context "when using a normal user" do
      let(:user) { FactoryBot.create(:user) }

      context "when there are not external elections" do
        it "doesn't display the external elections section" do
          visit chapter_path(chapter)
          expect(page).to_not have_text "External Elections"
        end
      end

      context "when there are external elections but no races in this chapter" do
        let!(:election) { FactoryBot.create(:election, :external, name: '2020 Elections', visibility: Visibility::VISIBILITY_SHOW_ALL) }

        it "displays the external elections section" do
          visit chapter_path(chapter)
          expect(page).to have_text "External Elections"
          expect(page).to have_text "2020 Elections"
          expect(page).to have_selector "a[href='#{election_races_path(election, chapter_id: chapter.id)}']"
        end
      end

      context "when there are external elections but and races in this chapter" do
        let!(:election) { FactoryBot.create(:election, :external, name: '2020 Elections', visibility: Visibility::VISIBILITY_SHOW_ALL) }
        let!(:race)     { FactoryBot.create(:race, election: election, name: 'Governor', chapter: chapter) }
        let!(:other_chapter_race)     { FactoryBot.create(:race, election: election, name: 'Governor', chapter: other_chapter) }

        it "displays the race" do
          visit chapter_path(chapter)
          expect(page).to have_text "External Elections"
          expect(page).to have_text "2020 Elections"
          expect(page).to have_text "Governor"
          expect(page).to have_selector "a[href='#{race_path(race, chapter_id: chapter.id)}']"
          expect(page).to_not have_selector "a[href='#{race_path(other_chapter_race, chapter_id: other_chapter.id)}']"
        end
      end

      context "when there is an internal election" do
        let!(:election) { FactoryBot.create(:election, :internal, chapter: chapter, name: 'Board Members', member_group: MemberGroup.find_by_scope_type('officers')) }

        it "doesn't display the internal election when the user cannot vote in the election" do
          visit chapter_path(chapter)
          expect(page).to_not have_text "Internal Elections"
          expect(page).to_not have_text "Board Members"
        end

        # it "displays the internal election if the user can vote in it" do
        #   user.officers << create(:officer, chapter: chapter)
        #   user.reload
        #   visit chapter_path(chapter)
        #   expect(page).to have_text "Internal Elections"
        #   expect(page).to have_text "Board Members"
        # end
      end
    end
  end

  describe "show members button available when user has rights to view members" do
    let(:chapter) { Chapter.find_by_name("Duluth") }

    before do
      visit chapter_path(chapter)
    end

    context "when testing for chapter items for all users" do
      let(:user) { FactoryBot.create(:user) }

      it "displays the Duluth chapter page" do
        expect(page).to have_text "Duluth"
        expect(page).to have_text "Activity"
        expect(page).to have_selector "a[href='#{chapter_path(chapter, tab: :governance)}']"
      end
    end

    context "when the user is a normal user" do
      let(:user) { FactoryBot.create(:user) }

      it "displays the view members button" do
        expect(page).to_not have_selector "a[href='#{chapter_members_path(chapter)}']"
        expect(page).to_not have_selector "a[href='#{chapter_members_path(chapter, show_potential_members: true)}']"
        expect(page).to_not have_selector "a[href='#{new_election_path(chapter_id: chapter.id)}']"
      end
    end

    context "when the user has member viewing privileges for this chapter" do
      let(:user) {
        FactoryBot.create(:user,
          role: Role.new(privileges:
                  [Privilege.new(subject: 'member',
                                 action: 'view',
                                 scope: {chapter_id: chapter.id}.to_json)]))
      }

      it "displays the view members button" do
        expect(page).to have_selector "a[href='#{chapter_members_path(chapter)}']"
      end
    end

    context "when the user has manage internal election privileges for this chapter" do
      let(:user) {
        FactoryBot.create(:user,
                           role: Role.new(privileges:
                                              [Privilege.new(subject: 'election',
                                                             action: 'manage_internal',
                                                             scope: {chapter_id: chapter.id}.to_json)]))
      }

      it "displays the view members button" do
        expect(page).to have_selector "a[href='#{new_election_path(chapter_id: chapter.id)}']"
      end
    end
  end
end

