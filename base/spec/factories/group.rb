FactoryBot.define do
  factory :group do |g|
    g.sequence(:name) { |n| "Group #{ n }" }
    g.author_id { |h| FactoryBot.create(:user).actor_id }
    g.user_author_id { |h| h.author_id }
  end
end
