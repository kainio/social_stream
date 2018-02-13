class Site::Current < Site
  attr_accessible :name
  class << self
    def instance
      @instance ||=
        first || create!(name: "Social Stream powered site")
    end
  end
end
