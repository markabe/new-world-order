git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"

run "rm public/index.html"
run "rm Gemfile"
run "rm -rf test"

git :commit => "-a -m 'Remove default index and clear Gemfile'"

file 'Gemfile', <<-CODE
source "http://rubygems.org"

gem "rails", "3.0.0.beta3"
CODE

unless options[:skip_activerecord]
  if require_for_database
    gem gem_for_database, :require => require_for_database
  else
    gem gem_for_database
  end
end

append_file 'Gemfile', <<-CODE

group "development" do
  gem "unicorn"
end

group "test" do
  gem "database_cleaner"
  gem "capybara"
  gem "cucumber-rails", :git => "git://github.com/aslakhellesoy/cucumber-rails.git"
  gem "factory_girl", "1.2.4", :require => nil
  gem "mocha"
  gem "rspec", "~> 2.0.0.beta.8"
  gem "rspec-rails", "~> 2.0.0.beta.8"
  gem "test-unit"  
end
CODE

run "bundle install"

git :commit => "-a -m  'Initial gem setup and bundle install'"

generate "rspec:install"

git :commit => "-a -m 'Rspec generated'"

generate "cucumber:skeleton", "--rspec", "--capybara"

git :commit => "-a -m 'Cucumber generated'"

rake "db:create:all db:migrate"

Say "All done!  Please edit your database.yml file with your database credentials and you should be all set!"