FactoryGirl.define do

  factory :post do
    sequence(:title) { |n| "Post's title #{n}" }
    sequence(:body) { |n| "Post's body #{n}" }
    user
  end

  factory :user do
    sequence(:email) { |n| "foo#{n}@example.com" }
    password "secretpass"
    password_confirmation { |p| p.password }

    factory :user_with_posts do

      ignore do
        posts_count 3
      end
     
      after(:create) do |user, evaluator|
        FactoryGirl.create_list(:post, evaluator.posts_count, user: user)
      end
    end
  end
end


