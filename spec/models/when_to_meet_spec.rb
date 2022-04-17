require 'rails_helper'

describe WhenToMeet do
  describe "#set_time_slot_from_checks_and_user" do
    it "adds a new check to a time slot" do
      subject.set_time_slot_from_checks_and_user([["check-1", "yes"]], WhenToMeet::User.new(name: "Bob", email: "a@b.com", is_creator: false))
      expect(subject.time_slots).to eq({"check-1" => ["a@b.com"]})
    end

    it "removes a check from a time slot" do
      subject.update(time_slots: {"check-1"=> ["a@b.com", "b@c.com"], "check-2" => ["b@c.com"]})
      subject.set_time_slot_from_checks_and_user([], WhenToMeet::User.new(name: "Bob", email: "b@c.com", is_creator: false))
      expect(subject.time_slots).to eq({"check-1" => ["a@b.com"]})
    end

    it "doesn't duplicate the same email in a time slot" do
      subject.time_slots = {"check-1" => ["a@b.com"]}
      subject.set_time_slot_from_checks_and_user([["check-1", "yes"]], WhenToMeet::User.new(name: "Bob", email: "a@b.com", is_creator: false))
      expect(subject.time_slots).to eq({"check-1" => ["a@b.com"]})
    end
  end
end
