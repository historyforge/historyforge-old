FactoryBot.define do
  factory :user do
    login { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'b1g_sekrit' }
    enabled { false }

    factory :active_user do
      enabled { true }
    end
  end
end
