require 'spec_helper'

describe User do
  let(:user) { create(:user) }

  describe 'full_name' do
    context 'when name is present' do
      it 'returns name' do
        expect(user.full_name).to eq(user.name)
      end
    end

    context 'when name is absent and nickname is present' do
      it 'returns nickname' do
        user.name = nil
        expect(user.full_name).to eq(user.nickname)
      end
    end

    context 'when name and nickname is absent and email is absent' do
      it 'returns email' do
        user.name = user.nickname = nil
        expect(user.full_name).to eq(user.email)
      end
    end
  end
end