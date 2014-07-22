require 'spec_helper'

describe UsersController do
  describe '#show' do
    let(:user) { mock_model User, id: 100000000 }
    let(:subject) { get :show, id: user.id }

    context 'when logged in' do
      login_user

      context 'when user found' do
        context 'when viewing own page' do
          before { allow(user).to receive(:id).and_return(@current_user.id) }
          it 'renders show template' do
            expect(subject).to render_template :show
          end

          it 'returns 200 status code' do
            expect(subject.status).to eq 200
          end
        end

        context 'when viewing other\'s page' do
          let(:new_user) { create(:user) }
          let(:subject) { get :show, id: new_user.id }

          it 'redirect to root_path' do
            expect(subject).to redirect_to root_path
          end

          it 'sets flash error message' do
            subject
            expect(flash[:error]).to eq('You are not authorized to perform this action!')
          end
        end
      end

      context 'when user not found' do
        it 'redirect to root_path' do
          expect(subject).to redirect_to root_path
        end

        it 'sets flash error message' do
          subject
          expect(flash[:error]).to eq('User not found')
        end
      end
    end

    context 'when not logged in' do
      it 'redirects to login page' do
        expect(subject).to redirect_to new_user_session_path
      end

      it 'sets flash alert message' do
        subject
        expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      end
    end
  end
end
