# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable

  devise :omniauthable, omniauth_providers: [:github]

  # Validations
  validates :bitcoin_address, bitcoin_address: true

  # Associations
  has_many :tips

  # Callbacks
  before_create :set_login_token!, unless: :login_token?

  # Instance Methods
  def github_url
    "https://github.com/#{nickname}"
  end

  def balance
    tips.decided.unpaid.sum(:amount)
  end

  def denom
    attributes['denom'].presence || denom.presence
  end

  def gravatar_bitcoin
    begin
      gravatar.get_value :currency, :bitcoin
    rescue URI::InvalidURIError, NoMethodError => e
      nil
    end
  end

  def gravatar_display_name
    begin
      gravatar.get_value :displayName
    rescue URI::InvalidURIError, NoMethodError => e
      nil
    end
  end

  def display_name
    attributes['display_name'].presence || name.presence || nickname.presence || email
  end

  def subscribed?
    !unsubscribed?
  end

  # Class Methods
  def self.update_cache
    includes(:tips).find_each do |user|
      user.update commits_count: user.tips.count
      user.update withdrawn_amount: user.tips.paid.sum(:amount)
    end
  end

  def self.create_with_omniauth!(auth_info)
    generated_password = Devise.friendly_token.first(Devise.password_length.min)
    create do |user|
      user.email    = auth_info.email
      user.password = generated_password
      user.nickname = auth_info.nickname
      user.display_name = auth_info.name
      user.skip_confirmation!
    end
  end

  def self.find_by_commit(commit)
    email = commit.commit.author.email
    nickname = commit.author.try(:login)

    find_by(email: email) || (nickname.blank? ? nil : find_by(nickname: nickname))
  end

  def ready_for_withdrawal?
    self.bitcoin_address.present? && self.balance >= CONFIG['min_payout']
  end

  private

  def gravatar
    @gravatar ||= Gravatar::new(email)
  end

  def set_login_token!
    loop do
      self.login_token = SecureRandom.urlsafe_base64
      break login_token unless User.exists?(login_token: login_token)
    end
  end
end
