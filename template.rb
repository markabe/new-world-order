git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"

run "rm public/index.html"
run "rm Gemfile"
run "rm -rf test"

git :commit => "-a -m 'Remove default index and Gemfile'"

file 'Gemfile', <<-CODE
source 'http://rubygems.org'

gem 'rails', '3.0.0.beta3'

gem 'sqlite3-ruby', :require => 'sqlite3'

group "development" do
  gem "unicorn"
end

group "test" do
  gem 'database_cleaner'
  gem 'capybara'
  gem 'cucumber-rails', :git => "git://github.com/aslakhellesoy/cucumber-rails.git"
  gem "factory_girl", "1.2.4", :require => nil
  gem "mocha"
  gem 'rspec', '~> 2.0.0.beta.8'
  gem 'rspec-rails', '~> 2.0.0.beta.8'
  gem 'test-unit'
end
CODE

run "bundle install"

git :commit => "-a -m  'Initial gem setup and bundle install'"

generate "rspec:install"

git :commit => "-a -m 'Rspec generated'"

generate "cucumber:skeleton", "--rspec", "--capybara"

git :commit => "-a -m 'Cucumber generated'"

rake "db:create:all db:migrate"
