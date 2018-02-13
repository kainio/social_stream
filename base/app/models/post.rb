class Post < ActiveRecord::Base
  include SocialStream::Models::Object
  
  attr_accessible :author_id, :owner_id, :text, :user_author_id, :author, :main_holder_object_ids, :add_holder_post_id, :owner, :user_author

  MAXIMUM_LENGTH = 140

  alias_attribute :text, :description
  validates :text, presence: true

  define_index do
    activity_object_index
  end

  def title
    description.truncate(30, :separator =>' ')
  end

end
