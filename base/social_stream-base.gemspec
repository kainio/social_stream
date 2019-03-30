# encoding: UTF-8
require File.join(File.dirname(__FILE__), 'lib', 'social_stream', 'base', 'version')

Gem::Specification.new do |s|
  s.name = "social_stream-base"
  s.version = SocialStream::Base::VERSION.dup
  s.summary = "Basic features for Social Stream, the core for building social network websites"
  s.description = "Social Stream is a Ruby on Rails engine providing your application with social networking features and activity streams.\n\nThis gem packages the basic functionality, along with basic actors (user, group) and activity objects (post and comments)"
  s.authors = [ "GING - DIT - UPM" ]
  s.homepage = "http://social-stream.dit.upm.es/"
  s.files = `git ls-files`.split("\n")
  s.license = 'MIT'

  # Runtime gem dependencies
  #
  # Do not forget to require the file at lib/social_stream/base/dependencies !
  #
  # Deep Merge support for Hashes
  s.add_runtime_dependency('deep_merge', '1.2.1')
  # Rails
  s.add_runtime_dependency('rails', '~>4.0.0')
  # Rails Engine Decorators
  s.add_runtime_dependency('rails_engine_decorators', '1.0.0')
  # Activity and Relation hierarchies
  s.add_runtime_dependency('ancestry', '3.0.1')
  # SQL foreign keys
  s.add_runtime_dependency('foreigner', '1.7.4')
  # Authentication
  s.add_runtime_dependency('devise', '3.5.10')
  s.add_runtime_dependency('devise-token_authenticatable', '0.4.10')
  # CRUD controllers
  s.add_runtime_dependency('inherited_resources', '1.7.2')
  # Slug generation
  s.add_runtime_dependency('stringex', '2.8.2')
  # Avatar attachments
  s.add_runtime_dependency('avatars_for_rails', '1.1.4')
  # jQuery
  s.add_runtime_dependency('jquery-rails', '3.1.4')
  # jQuery UI
  s.add_runtime_dependency('jquery-ui-rails', '6.0.1')
  # Select2 javascript library
  s.add_runtime_dependency('select2-rails', '4.0.3')
  # Authorization
  s.add_runtime_dependency('cancan', '1.6.10')
  # Pagination
  s.add_runtime_dependency('kaminari', '0.17.0')
  # OAuth client
  s.add_runtime_dependency('omniauth-socialstream', '0.1.3')
  s.add_runtime_dependency('omniauth-facebook', "1.6.0")
  s.add_runtime_dependency('omniauth-linkedin', '0.2.0')
  # Messages
  s.add_runtime_dependency('mailboxer', '0.13.0')
  # Tagging
  s.add_runtime_dependency('acts-as-taggable-on', '4.0.0')
  # Background jobs
  s.add_runtime_dependency('resque', '1.27.4')
  # Modernizr.js javascript library
  s.add_runtime_dependency('modernizr-rails', '2.7.1')
  # Sphinx search engine
  s.add_runtime_dependency('thinking-sphinx', "3.4.2")
  # Syntactically Awesome Stylesheets
  s.add_runtime_dependency('sass-rails', "5.0.7")
  # Bootstrap for Sass
  s.add_runtime_dependency('bootstrap-sass',  '2.3.2.0')
  # Customize ERB views
  s.add_runtime_dependency('deface', '1.0.2')
  # Autolink text blocks
  s.add_runtime_dependency('rails_autolink', '1.1.6')
  # I18n-js
  s.add_runtime_dependency('i18n-js', '3.0.5')
  # Strong Parameters
  #s.add_runtime_dependency('strong_parameters')
  # Flash messages
  s.add_runtime_dependency('protected_attributes', '1.1.4')
  s.add_runtime_dependency('flashy','~>0.0.1')

  # Development gem dependencies
  #
  # Integration testing
  s.add_development_dependency('capybara', '~>2.18.0')
  s.add_development_dependency('bundler-explain', '~>0.2.0')
  # Testing database
  s.add_development_dependency('sqlite3')
  
  s.add_development_dependency('test-unit', '~>3.2.7')

  # Specs
  s.add_development_dependency('rspec-rails', '~> 3.7.2')
  s.add_development_dependency('rspec-activemodel-mocks')

  # Fixtures
  s.add_development_dependency('factory_bot_rails','~> 4.8.2')
  # Population
  s.add_development_dependency('forgery', '~>0.7.0')
  # Continous integration
  s.add_development_dependency('ci_reporter', '~>2.0.0')
  # Scaffold generator
  s.add_development_dependency('nifty-generators', '~>0.4.6')
  # pry
  s.add_development_dependency('pry-rails')

end
