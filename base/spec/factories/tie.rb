FactoryBot.define do
  factory :tie do |t|
    t.association :contact
  end
end

# User ties

FactoryBot.define do
  factory :friend, :parent => :tie do |t|
    t.after(:build) { |u| u.relation = u.sender.relation_custom('friend') }
  end
end

FactoryBot.define do 
  factory :acquaintance, :parent => :tie do |t|
    t.after(:build) { |u| u.relation = u.sender.relation_custom('acquaintance') }
  end
end

FactoryBot.define do 
  factory :public, :parent => :tie do |t|
    t.after(:build) { |u| u.relation = Relation::Public.instance }
  end
end

FactoryBot.define do 
  factory :reject, :parent => :tie do |t|
    t.after(:build) { |u| u.relation = Relation::Reject.instance }
  end
end

FactoryBot.define do 
  factory :follow, :parent => :tie do |t|
    t.after(:build) { |u| u.relation = Relation::Follow.instance }
  end
end

# Group ties
FactoryBot.define do
  factory :g2u_tie, :parent => :tie do |t|
    t.contact { |c| FactoryBot.create(:group_contact) }
  end
end

FactoryBot.define do
  factory :member, :parent => :g2u_tie do |t|
    t.after(:build) { |u| u.relation = u.sender.relation_custom('member') }
  end
end

FactoryBot.define do
  factory :g2g_tie, :parent => :tie do |t|
    t.contact { |c| FactoryBot.create(:g2g_contact) }
  end
end

FactoryBot.define do
  factory :partner, :parent => :g2g_tie do |t|
    t.after(:build) { |u| u.relation = u.sender.relation_custom('partner') }
  end
end

FactoryBot.define do 
  factory :group_public, :parent => :g2g_tie do |t|
    t.after(:build) { |u| u.relation = Relation::Public.instance }
  end
end

