FactoryBot.define do
  factory :post do |p|
    p.sequence(:text)  { |n| "Post #{ n }" }
    p.author_id { FactoryBot.create(:friend).receiver.id }
    p.owner_id  { |q| Actor.find(q.author_id).received_ties.first.sender.id }
    p.user_author_id { |q| q.author_id }
  end
end

FactoryBot.define do
  factory :public_post, :parent => :post do |p|
    p.owner_id  { |q| q.author_id }
    p.relation_ids { |q| Array(Relation::Public.instance.id) }
  end
end

FactoryBot.define do
  factory :self_post, :parent => :post do |p|
    p.author_id { FactoryBot.create(:user).actor_id }
    p.owner_id  { |q| q.author_id }
    p.user_author_id { |q| q.author_id }
  end
end
