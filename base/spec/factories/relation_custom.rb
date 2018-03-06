FactoryBot.define do
  factory :relation_custom, :class => ::Relation::Custom do |c|
    c.sequence(:name) { |n| "Relation custom #{ n }" }
    c.actor { FactoryBot.create(:user).actor }
  end
end
