#upgrade to rails 4.0
---------------------

[fix] deprecation error at the model level like:
the following:

    has_many :spam_comments, conditions: { spam: true }, class_name: 'Comment'

should be rewritten as the following:

    has_many :spam_comments, -> { where spam: true }, class_name: 'Comment'

and

For example `scope :red, where(color: 'red')` should be changed to `scope :red, -> { where(color: 'red') }`

and

DEPRECATION WARNING: This dynamic method is deprecated. Please use e.g Post.find_or_create_by(name: 'foo') instead.

DEPRECATION WARNING: Calling #find(:first) is deprecated. Please call #first directly instead. 
You have also used finder options. These are also deprecated. Please build a scope instead of using finder options.
(called from find_by_email at (eval):2)

[i18n] upgrade the configuration of translations vendor/assets/javascripts/i18n/translations.js.erb

[Learn] inherited_resources gem
[test] should uncomment spec/controllers/groups_controller_spec.rb:154 and expect the sec to pass
[current failling spec] 
[Devise] move devise configuration from dummy application to SocialStream base and generate new devise views
[Learn] cancan ability
