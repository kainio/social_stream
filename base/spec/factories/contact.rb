FactoryBot.define do
  factory :contact do |c|
    c.sender   { |s| FactoryBot.create(:user).actor }
    c.receiver { |r| FactoryBot.create(:user).actor }
    c.user_author { |d| d.sender }
  end
end

FactoryBot.define do
  factory :self_contact, :parent => :contact do |c|
    c.receiver { |d| d.sender }
  end
end

FactoryBot.define do
  factory :group_contact, :parent => :contact do |g|
    g.sender { |s| FactoryBot.create(:group).actor }
    g.after(:build) { |h| h.user_author = h.sender.user_author }
  end
end

FactoryBot.define do
  factory :g2g_contact, :parent => :group_contact do |g|
    g.receiver { |r| FactoryBot.create(:group).actor }
  end
end
