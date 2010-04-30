git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"

run "rm public/index.html"
run "rm Gemfile"
run "rm -rf test"

git :commit => "-a -m 'Remove default index and clear Gemfile'"

# Rails default generator uses 'app_name' as the username for postgresql -- thats dumb
# We replace that with 'postgres' which is a more common development configuration
if options[:database] == "postgresql"
  gsub_file 'config/database.yml', "username: #{app_name}", "username: postgres"
  git :commit => "-a -m 'Use postgres user for database.yml'"
end

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
git :add => "."
git :commit => "-a -m  'Initial gems setup'"

generate "rspec:install"
gsub_file 'spec/spec_helper.rb', "# config.mock_with :mocha", "config.mock_with :mocha"
gsub_file 'spec/spec_helper.rb', "config.mock_with :rspec", "# config.mock_with :rspec"
git :add => "."
git :commit => "-a -m 'Rspec generated'"

generate "cucumber:skeleton", "--rspec", "--capybara"
git :add => "."
git :commit => "-a -m 'Cucumber generated'"

rake "db:create:all db:migrate"

say "All done!  Thanks for installing using the NEW WORLD ORDER"