source 'https://rubygems.org'

ruby '2.0.0'
gem "rails", "~> 4.0.0"

gem 'therubyracer'
gem 'less-rails'
gem 'twitter-bootstrap-rails'
gem 'faker'
gem 'will_paginate', '3.0.4'
gem 'bootstrap-will_paginate', '0.0.9'
gem 'jquery-rails', '~> 3.0.4'
gem 'pg', '~> 0.16.0'
gem 'slim-rails', '~> 2.0.1'
gem 'sass-rails',   '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier', '~> 2.1.2'
gem 'newrelic_rpm'

group :development, :test do
  gem 'rspec-rails', '~> 2.14.0'
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'guard-spork', '~> 1.5.1'  
  gem 'spork', '~> 0.9.2'
  gem 'travis-lint', :require => false
  gem 'coveralls', :require => false
end

group :production do
  gem 'rails_12factor'
end

group :test do
  gem 'rb-fsevent', :require => false
  gem 'growl'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'guard-rspec'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
end
