# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user && user.nickname.present?

    can %i[update decide_tip_amounts], Project, collaborators: { login: user.nickname }
  end
end
