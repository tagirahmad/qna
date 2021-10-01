# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user)        { create :user }
  let(:question)    { create :question, :with_file, user: user }
  let(:second_user) { create :user }

  describe 'DELETE #destroy' do
    describe 'as an author' do
      before { login user }

      let(:destroy_file) { delete :destroy, params: { id: question.files.first.id, format: :js } }

      it 'deletes file from active storage' do
        expect do
          destroy_file
        end.to change(question.files, :count).by(-1)
      end

      it 'get flash alert message' do
        delete :destroy, params: { id: question.files.first.id, format: :js }
        expect(flash[:alert]).to eq "#{question.files.first.filename} was successfully deleted!"
      end
    end

    describe 'as not an author' do
      before { login second_user }

      it 'does not delete the file' do
        expect do
          delete :destroy, params: { id: question.files.first.id, format: :js }
        end.not_to change(question.files, :count)
      end

      it 'get flash error message' do
        delete :destroy, params: { id: question.files.first.id, format: :js }
        expect(flash[:error]).to eq 'Not enough permission: for delete'
      end
    end
  end
end
