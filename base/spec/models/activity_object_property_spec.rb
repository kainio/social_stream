require 'rails_helper'

describe ActivityObjectProperty do
  describe "siblings" do
    it "should work" do
      holder, one, two, three = 4.times.map{ FactoryBot.create(:post) }

      p = ActivityObjectProperty.create! activity_object_id: holder.activity_object_id,
                                         property_id:        one.activity_object_id

      expect(p.siblings).to be_blank
      expect(p.main).to be true

      q = ActivityObjectProperty.create! activity_object_id: holder.activity_object_id,
                                         property_id:        two.activity_object_id

      expect(p.siblings).to include(q)
      expect(p.reload.main).to be true
      expect(q.main).to be_falsy

      r = ActivityObjectProperty.create! activity_object_id: holder.activity_object_id,
                                         property_id:        three.activity_object_id,
                                         main:               true

      expect(r.siblings).to include(p)
      expect(r.siblings).to include(q)

      expect(p.reload.main).to be_falsy
      expect(q.reload.main).to be_falsy
      expect(r.main).to be true
    end
  end

  context "with main_holder_object_ids" do
    it "should be created" do
      @holder = FactoryBot.create(:post)

      prop = Post.create! text: "Text",
                          author: @holder.author,
                          main_holder_object_ids: [ @holder.activity_object_id ]

      expect(@holder.posts).to include(prop)
      expect(@holder.main_post).to eq(prop)
    end
  end

  context "with add_holder_post_id" do
    it "should be created" do
      @holder = FactoryBot.create(:post)

      prop = Post.create! text: "Text",
                          author: @holder.author,
                          add_holder_post_id: @holder.id

      expect(@holder.posts).to include(prop)
      expect(@holder.main_post).to eq(prop)
    end
  end
end
