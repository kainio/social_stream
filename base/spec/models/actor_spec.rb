require 'rails_helper'

describe Actor do
  it "should generate slug" do
    expect(FactoryBot.create(:user).actor.slug).to be_present
  end

  it "should generate different slug" do
    a = FactoryBot.create(:user).actor
    b = FactoryBot.create(:user, :name => a.name).actor

    expect(a.name).to eq(b.name)
    expect(a.slug).to_not eq(b.slug)
  end

  it "should generate relations" do
    expect(FactoryBot.create(:user).relation_customs).to be_present
  end

  context 'pending contacts' do
    it 'should not include self' do
      a = FactoryBot.create(:user).actor
      c = a.contact_to!(a)

      expect(a.pending_contacts).to_not include(c)
    end
  end

  it 'should generate suggestion' do
    10.times do
      FactoryBot.create(:user)
    end

    sgs = FactoryBot.create(:user).suggestions(5)

    expect(sgs.size).to be(5)

    sgs_names = sgs.map{ |s| s.receiver_subject.name }.compact

    expect(sgs.size).to be(5)
  end

  it "should be destroyed" do
    u = FactoryBot.create(:user)
    a = u.actor

    u.destroy

    expect(Actor.find_by_id(a.id)).to be_nil
  end
end
