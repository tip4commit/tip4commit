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

  describe "routing" do
    it "routes GET /users to User#index" do
      expect({ :get => "/users" }).to route_to(
        :controller => "users" ,
        :action     => "index" )
    end

    it "routes GET /users/nick-name321 to User#show" do
      expect({ :get => "/users/nick-name321" }).to route_to(
        :controller => "users" ,
        :action     => "show"  ,
        :nickname   => "nick-name321"     )
    end

    it "routes GET /users/login to User#login" do
      expect({ :get => "/users/login" }).to route_to(
        :controller => "users" ,
        :action     => "login" )
    end

    it "routes GET /users/1/tips to Tips#index" do
      expect({ :get => "/users/1/tips" }).to route_to(
        :controller => "tips"  ,
        :action     => "index" ,
        :user_id    => "1"     )
    end
  end

  describe "pretty url routing" do
    let(:user) { create(:user) }

    it "regex rejects reserved user paths" do
      # accepted pertty url usernames
      should_accept = [' ' , 'logi' , 'ogin' , 's4c2' , '42x' , 'nick name' , 'kd']
      # reserved routes (rejected pertty url usernames)
      should_reject = ['' , '1' , '42']

      accepted = should_accept.select {|ea|  ea =~ /\D+/}
      rejected = should_reject.select {|ea| (ea =~ /\D+/).nil? }
      (expect(accepted.size).to eq(should_accept.size)) &&
      (expect(rejected.size).to eq(should_reject.size))
    end

    it "routes GET /users/:nickname to User#show" do
      expect({ :get => "/users/#{user.nickname}" }).to route_to(
        :controller => "users" ,
        :action     => "show"  ,
        :nickname   => "kd"    )
    end

    it "routes GET /users/:nickname/tips to Tips#index" do
      expect({ :get => "/users/#{user.nickname}/tips" }).to route_to(
        :controller => "tips"  ,
        :action     => "index" ,
        :nickname   => "kd"    )
    end
  end
end
