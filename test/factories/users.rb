FactoryGirl.define do

  factory :user do
    sequence(:username) { |n| "username#{n}" }
    password '12345678'
    role User::CUSTOMER
    first_name 'John'
    last_name 'Doe'

    trait :admin do
      role User::ADMIN
    end

  end

end