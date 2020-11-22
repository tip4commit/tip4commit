# frozen_string_literal: true

class TippingPoliciesText < ApplicationRecord
  belongs_to :project
  belongs_to :user
end
