require 'rails_helper'

describe Election do
  let!(:questionnaire)              { FactoryGirl.create(:questionnaire) }
  let!(:questionnaire_section_1)    { FactoryGirl.create(:questionnaire_section, questionnaire: questionnaire, order_index: 1, title: 'Section 1') }

  let!(:ranked_choice_question)     { FactoryGirl.create(:question, questionnaire_section: questionnaire_section_1, question_type: Question::QUESTION_TYPE_RANKED_CHOICE, order_index: 1) }
  let!(:ranked_choice_1)            { FactoryGirl.create(:choice, question: ranked_choice_question, title: 'ranked choice 1', order_index: 1) }
  let!(:ranked_choice_2)            { FactoryGirl.create(:choice, question: ranked_choice_question, title: 'ranked choice 2', order_index: 2) }
  let!(:ranked_choice_3)            { FactoryGirl.create(:choice, question: ranked_choice_question, title: 'ranked choice 2', order_index: 3) }
  let!(:ranked_choice_4)            { FactoryGirl.create(:choice, question: ranked_choice_question, title: 'ranked choice 2', order_index: 4) }

  let!(:multiple_choice_question)   { FactoryGirl.create(:question, questionnaire_section: questionnaire_section_1, question_type: Question::QUESTION_TYPE_CHECKBOXES, order_index: 2) }
  let!(:multiple_choice_1)          { FactoryGirl.create(:choice, question: multiple_choice_question, title: 'checkbox choice 1', order_index: 1) }
  let!(:multiple_choice_2)          { FactoryGirl.create(:choice, question: multiple_choice_question, title: 'checkbox choice 2', order_index: 2) }

  let(:ranked_choice_answer_1)      { FactoryGirl.create(:answer, question: ranked_choice_question, text: '1:::2:::3:::4', order_index: 1) }
  let(:ranked_choice_answer_2)      { FactoryGirl.create(:answer, question: ranked_choice_question, text: '1:::2:::4:::3', order_index: 2) }
  let(:ranked_choice_answer_3)      { FactoryGirl.create(:answer, question: ranked_choice_question, text: '2:::1:::3:::4', order_index: 3) }

  # adding in these two requires a second round where 3's vote gives the election to 2 (because of the 2nd place vote for 2)
  let(:ranked_choice_answer_4)      { FactoryGirl.create(:answer, question: ranked_choice_question, text: '2:::1:::3:::4', order_index: 4) }
  let(:ranked_choice_answer_5)      { FactoryGirl.create(:answer, question: ranked_choice_question, text: '3:::2:::1:::4', order_index: 5) }

  let(:multiple_choice_answer_1)    { FactoryGirl.create(:answer, question: multiple_choice_question, text: 'checkbox choice 1') }
  let(:multiple_choice_answer_2)    { FactoryGirl.create(:answer, question: multiple_choice_question, text: 'checkbox choice 2') }
  let(:multiple_choice_answer_3)    { FactoryGirl.create(:answer, question: multiple_choice_question, text: 'checkbox choice 2') }
  let(:multiple_choice_answer_4)    { FactoryGirl.create(:answer, question: multiple_choice_question, text: 'checkbox choice 1:::checkbox choice 2') }

  let(:election)                    { FactoryGirl.create(:election, :internal, questionnaire: questionnaire) }

  describe "#tally_answers" do
    context "when testing ranked choice votes" do
      context "when the first place vote getting gets above the threshold" do
        before do
          ranked_choice_answer_1; ranked_choice_answer_2; ranked_choice_answer_3
        end

        it "counts the choices correctly" do
          election.tally_answers

          expect(questionnaire.choice_tallies.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "1", round: 1).first.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "2", round: 1).first.count).to eq(1)

          expect(ranked_choice_question.num_rounds).to eq(1)
          expect(ranked_choice_question.winner).to eq(ranked_choice_1)
        end
      end

      context "when it requires a 2nd round" do
        before do
          ranked_choice_answer_1; ranked_choice_answer_2; ranked_choice_answer_3
          ranked_choice_answer_4; ranked_choice_answer_5
        end

        it "counts the choices correctly" do
          election.tally_answers

          expect(questionnaire.choice_tallies.where(round: 1).count).to eq(3)
          expect(questionnaire.choice_tallies.where(value: "1", round: 1).first.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "2", round: 1).first.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "3", round: 1).first.count).to eq(1)

          expect(questionnaire.choice_tallies.where(round: 2).count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "1", round: 2).first.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "2", round: 2).first.count).to eq(3)

          expect(ranked_choice_question.num_rounds).to eq(2)
          expect(ranked_choice_question.winner).to eq(ranked_choice_2)
        end
      end
    end

    context "when testing multiple choice votes" do
      context "when the first place vote getting gets above the threshold" do
        before do
          multiple_choice_answer_1; multiple_choice_answer_2; multiple_choice_answer_3; multiple_choice_answer_4
        end

        it "counts the choices correctly" do
          election.tally_answers

          expect(questionnaire.choice_tallies.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "checkbox choice 1").first.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "checkbox choice 2").first.count).to eq(3)
        end
      end
    end
  end
end

