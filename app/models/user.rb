class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:github]

  validates :bitcoin_address, :bitcoin_address => true

  has_many :tips

  def github_url
    "https://github.com/#{nickname}"
  end

  def balance
  	tips.unpaid.sum(:amount)
  end

  after_create :generate_login_token!
  def generate_login_token!
    if login_token.blank?
      self.update login_token: SecureRandom.urlsafe_base64
    end
  end

  def full_name
    if !name.blank?
      name
    elsif !nickname.blank?
      nickname
    else
      email
    end
  end

  def self.update_cache
    find_each do |user|
      user.update commits_count: user.tips.count
      user.update withdrawn_amount: user.tips.paid.sum(:amount)
    end
  end
end
