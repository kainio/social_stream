# Generator social_stream:install has modified this file. Please,
# check everything is working ok, specially if the former `Ability`
# class inherited from another class or included another module
class Ability
  include SocialStream::Ability

  def initialize(subject)
    super

    # Add your authorization rules here
    # For instance:
    #    can :create, Comment
    #    can [:create, :destroy], Post do |p|
    #      p.actor_id == Actor.normalize_id(subject)
    #    end
  end
end