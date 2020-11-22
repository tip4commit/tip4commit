# frozen_string_literal: true

require 'spec_helper'

describe UserMailer do
  describe 'new_tip' do
    let(:user) do
      mock_model(
        User,
        name: 'kd',
        email: 'kd.engineer@yahoo.co.in',
        display_name: 'kuldeep aggarwal',
        login_token: 'my login token',
        balance: 10
      )
    end
    let(:project) { mock_model Project, full_name: 'logger-extension' }
    let(:tip) { mock_model Tip, amount: 0.0001, project: project }
    let(:mail) { UserMailer.new_tip(user, tip) }

    it 'renders the subject' do
      expect(mail.subject).to eq 'You received a tip for your commit'
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq [user.email]
    end

    it 'renders the sender email' do
      expect(mail.from).to eq ['no-reply@tip4commit.com']
    end

    it 'assigns user\'s display_name' do
      expect(mail.body.encoded).to match(user.display_name)
    end

    it 'assigns users\' balance' do
      expected_text = [
        'Please, log in and tell us your bitcoin address to get it.</p>',
        '<p>Your current balance is <nobr>0.00000010 Ƀ</nobr>'
      ].join("\r\n")
      expect(mail.body.encoded).to match expected_text
    end

    it 'useses secure protocol for links' do
      expect(mail.body.encoded).to match('https')
    end
  end
end
