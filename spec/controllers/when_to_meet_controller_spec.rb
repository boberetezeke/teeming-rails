require 'rails_helper'

describe WhenToMeetController do
  describe "create" do
    let(:when_to_meet) { FactoryBot.create(:when_to_meet) }

    it "creates the when to meet object" do
      post :create, params: {
        when_to_meet: {
          name: 'Meeting',
          user_name: 'name',
          user_email: 'a@email.com'
        }
      }
      when_to_meet = WhenToMeet.last
      expect(response).to redirect_to(when_to_meet_path(when_to_meet))
      expect(when_to_meet.name).to eq("Meeting")
    end

    it "re-renders if there are validation errors" do
      post :create, params: {
        id: when_to_meet.id,
        when_to_meet: {
          name: '',
          user_name: '',
          user_email: 'email.com'
        }
      }
      expect(response).to render_template('new')
    end
  end

  describe "signup" do
    let(:when_to_meet) { FactoryBot.create :when_to_meet }

    it "returns an error with no name or email" do
      post :signup, params: {
        id: when_to_meet.id, user_name: '', user_email: '',
        "check-2022-04-02-9:00 am" => "no"
      }
      expect(response).to render_template('show')
    end

    it "creates a user" do
      post :signup, params: {
        id: when_to_meet.id, user_name: 'name', user_email: 'a@email.com',
        "check-2022-04-02-9:00 am" => "no"
      }
      when_to_meet.reload
      expect(response).to redirect_to(when_to_meet_user_path(when_to_meet, user_id: when_to_meet.users.first.id))
      expect(when_to_meet.users.size).to eq(1)
      user = when_to_meet.users.first
      expect(user.email).to eq('a@email.com')
      expect(user.name).to eq('name')
      expect(user.id).to eq('a')
      expect(user.is_creator).to be_falsy
    end

    it "updates a user's name and email" do
      when_to_meet.update(
        users: [WhenToMeet::User.new(name: "abc", email: "a@email.com", is_creator: false, id: "a")],
        time_slots: { "check-2022-04-02-9:00 am" => ["abc@email.com"] }
      )
      post :signup, params: {
        id: when_to_meet.id, user_id: "a", user_name: 'name', user_email: 'abc@email.com',
        "check-2022-04-02-9:00 am" => "no", "check-2022-04-02-10:00 am" => "no",
      }
      when_to_meet.reload
      expect(when_to_meet.users.size).to eq(1)
      expect(when_to_meet.time_slots).to eq(
        {
          "check-2022-04-02-9:00 am" => ["abc@email.com"],
          "check-2022-04-02-10:00 am" => ["abc@email.com"],
        }
      )
      user = when_to_meet.users.first
      expect(user.name).to eq("name")
      expect(user.email).to eq("abc@email.com")
    end
  end
end