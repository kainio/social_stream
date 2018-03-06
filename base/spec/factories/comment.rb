FactoryBot.define do
  factory :comment do |p|
    p.sequence(:text)  { |n| "Comment #{ n }" }
    p.author_id { FactoryBot.create(:friend).receiver.id }
    p.owner_id  { |q| Actor.find(q.author_id).received_ties.first.sender.id }
    p.user_author_id { |q| q.author_id }
  end
end
