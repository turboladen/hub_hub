FactoryGirl.define do
  factory :user, aliases: %i[owner] do
    sequence(:email) do
      "email#{User.count + 1}@test.com"
    end

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password 'password'
    password_confirmation { password }
    admin false
    banned false

    trait :banned do
      banned true
    end

    trait :admin do
      admin true
    end
  end
end
