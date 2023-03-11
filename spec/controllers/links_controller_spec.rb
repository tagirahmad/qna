# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user)            { create(:user) }
  let(:second_user)     { create(:user) }
  let!(:question) { create(:question, user:) }
  let!(:link)     { create(:link, linkable: question) }

  let(:delete_link) { delete :destroy, params: { id: link }, format: :js }

  describe 'DELETE #destroy' do
    context 'when authorized user deletes link' do
      it 'deletes link' do
        login user
        expect { delete_link }.to change(question.links, :count).by(-1)
      end
    end

    context 'when unauthorized user tries to delete link' do
      before do
        login second_user
        delete_link
      end

      it 'user tries to delete not his link' do
        expect { response }.not_to change(question.links, :count)
      end

      it 'shows error message' do
        expect(response.body).to have_content 'You are not authorized to access this page.'
      end
    end

    context 'when unauthenticated user' do
      before { delete_link }

      it 'tries to delete link' do
        expect { response }.not_to change(question.links, :count)
      end

      it 'shows error message' do
        expect(response.body).to have_content 'You need to sign in or sign up before continuing'
      end
    end
  end
end
