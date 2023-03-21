# frozen_string_literal: true

FactoryBot.define do
  factory :wallet do
    name { 'test wallet' }
    xpub do
      'xpub661MyMwAqRbcFepxYZyGLKMTkTPDvbfLaoYDbw4d4iQT5SycGiJQREuraJ2N6Uh' \
        'LGPcjXDhnARdtcUhgqN3a2dgQ3Dx8u1chtk8Rx16LrWg'
    end
  end
end
