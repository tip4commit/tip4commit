require 'spec_helper'

describe User, type: :model do
  let(:user) { create(:user) }

  describe 'full_name' do
    context 'when name is present' do
      it 'returns name' do
        expect(user.display_name).to eq(user.name)
      end
    end

    context 'when name is absent and nickname is present' do
      it 'returns nickname' do
        user.name = nil
        expect(user.display_name).to eq(user.nickname)
      end
    end

    context 'when name and nickname is absent and email is absent' do
      it 'returns email' do
        user.name = user.nickname = nil
        expect(user.display_name).to eq(user.email)
      end
    end
  end

  describe 'bitcoin_address' do
    context 'when address is blank' do
      it 'should be valid' do
        user.bitcoin_address = ''
        expect(user).to be_valid
      end
    end

    context 'when address is valid' do
      it 'should be valid' do
        user.bitcoin_address = '1M4bS4gPyA6Kb8w7aXsgth9oUZWcRk73tQ'
        expect(user).to be_valid
      end
    end

    context 'when address is not valid' do
      it 'should not be valid' do
        user.bitcoin_address = '1M4bS4gPyA6Kb8w7aXsgth9oUZXXXXXXXX'
        expect(user).not_to be_valid
      end
    end

  end
end
