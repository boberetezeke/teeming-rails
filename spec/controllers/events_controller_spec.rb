require 'rails_helper'

describe EventsController do
  include Devise::Test::ControllerHelpers

  let!(:user)                { FactoryBot.create(:user) }
  let!(:chapter)             { FactoryBot.create(:chapter) }
  let!(:other_chapter)       { FactoryBot.create(:chapter) }
  let!(:edit_events_role)    { FactoryBot.create(:role, privileges: [Role.new.new_write_events_privilege(scope: {chapter_id: chapter.id})]) }
  let!(:edit_events_user)    { FactoryBot.create(:user, role: edit_events_role) }
  let!(:edit_events_role_other_chapter)    { FactoryBot.create(:role, privileges: [Role.new.new_write_events_privilege(scope: {chapter_id: other_chapter.id})]) }
  let!(:edit_events_user_other_chapter)    { FactoryBot.create(:user, role: edit_events_role_other_chapter) }

  let!(:event_1_unpublished) { FactoryBot.create(:event, name: 'unpublished', chapter: chapter) }
  let!(:event_2_published)   { FactoryBot.create(:event, :published, name: 'published', chapter: chapter) }

  describe "index" do
    it "shows only published events for regular users" do
      sign_in user
      get :index, params: { chapter_id: chapter.id }
      expect(assigns(:events)).to eq([event_2_published])
    end

    it "shows all events for event write users" do
      sign_in edit_events_user
      get :index, params: { chapter_id: chapter.id }
      expect(assigns(:events).sort_by(&:name)).to eq([event_2_published, event_1_unpublished])
    end

    it "shows only published events for event write users for a different chapter" do
      sign_in edit_events_user_other_chapter
      get :index, params: { chapter_id: chapter.id }
      expect(assigns(:events).sort_by(&:name)).to eq([event_2_published])
    end
  end

  describe "show" do
    context "when logged in as a regular user" do
      before do
        sign_in user
      end

      it "shows published event" do
        get :show, params: { id: event_2_published.id }
        expect(assigns(:event)).to eq(event_2_published)
        expect(response).to be_ok
      end

      it "doesn't show unpublished event" do
        get :show, params: { id: event_1_unpublished.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context "when logged in as a write events user" do
      before do
        sign_in edit_events_user
      end

      it "shows published event" do
        get :show, params: { id: event_2_published.id }
        expect(assigns(:event)).to eq(event_2_published)
        expect(response).to be_ok
      end

      it "shows unpublished event" do
        get :show, params: { id: event_1_unpublished.id }
        expect(assigns(:event)).to eq(event_1_unpublished)
        expect(response).to be_ok
      end
    end
  end

  describe "publish" do
    it "fails to publish when a regular user does it" do
      sign_in user
      put :publish, params: { id: event_1_unpublished.id }
      expect(response).to redirect_to(root_path)
    end

    it "fails to publish if already published" do
      sign_in edit_events_user
      put :publish, params: { id: event_2_published.id }
      expect(flash["alert"]).to eq("Event is already published")
    end

    it "fails to publish when no time is set" do
      sign_in edit_events_user
      event_1_unpublished.update(occurs_at: nil)
      put :publish, params: { id: event_1_unpublished.id }
      expect(flash["alert"]).to eq("Can't publish event without a time set")
    end
  end
end

