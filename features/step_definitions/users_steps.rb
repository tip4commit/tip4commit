
def create_user nickname , has_bitcoiin_address
  User.create do |user|
    user.name            = nickname
    user.email           = "#{nickname}@example.com"
    user.bitcoin_address = '1AFgARu7e5d8Lox6P2DSFX3MW8BtsVXEn5' if has_bitcoiin_address
    user.nickname        = nickname
    user.password        = Devise.friendly_token.first(Devise.password_length.min)
    user.skip_confirmation!
  end
end

Given /^a user named "(.*?)" exists (with|without?) a bitcoin address$/ do |nickname , with|
  (@users ||= {})[nickname] ||= (create_user nickname , (with.eql? 'with'))
end
