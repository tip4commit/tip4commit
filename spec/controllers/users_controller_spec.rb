# frozen_string_literal: true

require 'spec_helper'

describe UsersController, type: :controller do
  describe 'GET #index' do
    let(:subject) { get :index }

    it 'renders index template' do
      expect(subject).to render_template :index
    end

    it 'returns 200 status code' do
      expect(subject.status).to eq 200
    end

    it 'assigns @users' do
      subject
      expect(assigns[:users].name).to eq 'User'
    end
  end

  describe '#show' do
    let(:user) { create(:user) }
    let(:subject) { get(:show, params: { nickname: user.nickname }) }

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

          it 'assigns @user' do
            subject
            expect(assigns[:user].name).to eq 'kd'
          end

          it 'assigns @user_tips' do
            subject
            expect(assigns[:user_tips].name).to eq 'Tip'
          end

          it 'assigns @recent_tips' do
            subject
            expect(assigns[:recent_tips].class).to eq Array
          end
        end

        context 'when viewing other\'s page' do
          let(:new_user) { create(:user) }
          let(:subject) { get(:show, params: { id: new_user.id }) }

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
        let(:subject) { get(:show, params: { nickname: 'unknown-user' }) }

        it 'redirect to users_path' do
          expect(subject).to redirect_to users_path
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

  describe '#update' do
    login_user

    it 'cannot set payout hold through params' do
      put :update, params: { id: @current_user.id,
                             user: { payout_hold: '1', payout_hold_reason: 'sneaky', display_name: 'New' } }
      @current_user.reload
      expect(@current_user.display_name).to eq 'New'
      expect(@current_user.payout_hold).to be false
      expect(@current_user.payout_hold_reason).to be_nil
    end

    it 'cannot release a hold through params' do
      @current_user.hold_payouts!('review')
      put :update, params: { id: @current_user.id,
                             user: { payout_hold: '0', payout_hold_reason: '' } }
      expect(@current_user.reload).to be_payout_hold
      expect(@current_user.payout_hold_reason).to eq 'review'
    end
  end

  describe 'payout hold notice' do
    render_views
    login_user

    before { stub_gravatar_profiles }

    it 'is shown to the held user on their own profile' do
      @current_user.hold_payouts!('review')
      get :show, params: { nickname: @current_user.nickname }
      expect(response.body).to include('Payouts for this account are paused pending a review.')
    end

    it 'is not shown when not held' do
      get :show, params: { nickname: @current_user.nickname }
      expect(response.body).not_to include('Payouts for this account are paused')
    end
  end
end
