# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }

  describe "#author_of?" do
    let(:user)          { create :user }
    let(:second_user)   { create :user }
    let(:question)      { create :question }
    
    context "question" do
      let(:user_question) { create :question, user: user }

      it "user is the author of the question" do
        expect(user).to be_author_of(user_question)
      end

      it "user is not the author of the question" do
        expect(second_user).to_not be_author_of(user_question)
      end
    end
    
    context "answer" do
      let(:user_answer) { create :answer, user: user, question: question }

      it "user is the author of the answer" do
        expect(user).to be_author_of(user_answer)
      end

      it "user is not the author of the answer" do
        expect(second_user).to_not be_author_of(user_answer)
      end
    end
  end
end
